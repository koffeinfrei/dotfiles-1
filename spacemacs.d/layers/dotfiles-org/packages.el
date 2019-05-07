(setq dotfiles-org-packages
 '(
   org
   org-agenda
   org-agenda-property
  ))

(defun dotfiles-org/post-init-org ()
  (setq
   calendar-week-start-day 1
   calendar-day-name-array (locale-info 'days)
   calendar-month-name-array (locale-info 'months)

   org-agenda-buffer-name "*agenda*"
   org-agenda-clockreport-parameter-plist '(:link t :maxlevel 5)
   org-agenda-dim-blocked-tasks nil
   org-agenda-files '("~/org")
   org-agenda-include-diary nil
   org-agenda-show-inherited-tags nil
   org-agenda-window-setup 'only-window
   org-attach-directory "attachments/"
   org-blank-before-new-entry '((heading . auto) (plain-list-item . nil))
   org-clock-history-length 25
   org-clock-in-resume t
   org-clock-mode-line-total 'current
   org-clock-out-remove-zero-time-clocks t
   org-clock-out-when-done nil
   org-clock-persist t
   org-clock-clocktable-default-properties
   '(:block today)
   org-clocktable-defaults
   '(:scope file-with-archives :properties ("CATEGORY")
     :indent t :link t :narrow 40!)
   org-columns-default-format "%TODO %40ITEM %SCHEDULED %DEADLINE %CLOCKSUM"
   org-cycle-separator-lines 1
   org-directory "~/org"
   org-download-method 'attach
   org-enforce-todo-dependencies t
   org-fontify-done-headline t
   org-habit-following-days 5
   org-habit-preceding-days 35
   org-habit-show-done-always-green t
   org-log-into-drawer t
   org-log-redeadline nil
   org-log-refile nil
   org-log-reschedule nil
   org-outline-path-complete-in-steps nil
   org-refile-allow-creating-parent-nodes t
   org-refile-targets '((dotfiles/org-refile-targets :maxlevel . 3))
   org-refile-use-outline-path 'file
   org-startup-align-all-tables t
   org-startup-folded 'content
   org-startup-indented t
   org-tag-persistent-alist
   '(("work"   . ?w))
   org-todo-keywords
   '((sequence "TODO" "NEXT" "STARTED" "WAITING" "|" "DONE"))
   org-todo-keyword-faces
   '(("NEXT"    . "#FD971F")
     ("STARTED" . "#AE81FF")
     ("WAITING" . "#E6DB74")
     ("DONE" . org-done))
  )

  (let* ((task-list-options
          '((org-agenda-sorting-strategy '((todo timestamp-up category-keep)))
            (org-agenda-property-list '("SCHEDULED" "DEADLINE" "CLOCKSUM"))
            (org-agenda-tags-column -70)
            (org-agenda-property-column 70)))
         (task-list
          `((todo "STARTED" ,(cons '(org-agenda-overriding-header "Started tasks:") task-list-options))
            (todo "NEXT" ,(cons '(org-agenda-overriding-header "Next tasks:") task-list-options))
            (todo "WAITING" ,(cons '(org-agenda-overriding-header "Waiting tasks:") task-list-options))
            (todo "TODO" ,(cons '(org-agenda-overriding-header "Other tasks:") task-list-options)))))
    (setq
     org-agenda-custom-commands
     `(
       ("o" "Agenda for home context"
        ,(cons '(agenda "") task-list)
        ((org-agenda-tag-filter-preset '("-work"))
         (org-agenda-use-time-grid nil)))
       ("w" "Agenda for work context"
        ,(cons '(agenda "") task-list)
        ((org-agenda-tag-filter-preset '("+work"))))

       ("O" "Review home tasks" ,task-list
        ,(cons '(org-agenda-tag-filter-preset '("-work")) task-list-options))
       ("W" "Review work tasks" ,task-list
        ,(cons '(org-agenda-tag-filter-preset '("+work")) task-list-options))
      )))

  (setq
   org-capture-templates
   '(
     ("c" "inbox" entry (file+olp "organizer.org" "Inbox")
      "* NEXT %?"
      :empty-lines-after 1)
     ("b" "basteln" entry (file+olp "organizer.org" "Projects" "Basteln")
      "* TODO %?")
     ("e" "emacs" checkitem (file+olp "organizer.org" "Projects" "Emacs" "Inbox")
      "- [ ] %?")

     ("w" "work todo" entry (file+olp "work.org" "Inbox")
      "* NEXT %?")
     ("p" "work project" entry (file+olp "work.org" "Projects")
      "* NEXT %?\n:PROPERTIES:\n:CREATED: %U\n:END:")

     ("n" "clock note" item (clock)
      "- %U %?")
    )
  )

  (add-hook 'org-mode-hook 'visual-line-mode)
  (add-hook 'calendar-load-hook (lambda () (calendar-set-date-style 'european)))

  ;; enable org-mode for additional extensions
  (add-to-list 'auto-mode-alist '("\\.org_archive$" . org-mode))

  ;; save org buffers when idle or the window loses focus
  (add-hook 'auto-save-hook (lambda () (dotfiles/silence (org-save-all-org-buffers))))
  (add-hook 'focus-out-hook (lambda () (dotfiles/silence (org-save-all-org-buffers))))

  (with-eval-after-load 'org
    (add-to-list 'org-modules 'org-habit)
    (org-clock-persistence-insinuate)

    ;; use T to cycle backwords through todo states
    (evil-define-key 'normal evil-org-mode-map (kbd "T") 'org-shiftleft)

    ;; override Spacemacs keybinding
    (spacemacs/set-leader-keys
      "Cc" (lambda () (interactive) (org-capture nil "c")))
  )

  ;; auto-save buffers in agenda
  (advice-add 'org-agenda-quit :before 'org-save-all-org-buffers)
  (advice-add 'org-agenda-redo :before 'org-save-all-org-buffers)

  ;; shrink capture window and start in insert mode
  (add-hook
   'org-capture-mode-hook
   (lambda ()
     (fit-window-to-buffer (selected-window) 10)
     (shrink-window-if-larger-than-buffer)))
  (add-hook 'org-capture-mode-hook 'evil-insert-state)

  ;; set clocked tasks to STARTED state
  (add-hook 'org-clock-in-hook 'dotfiles/org-start-task)

  ;; save files when clocking tasks
  (add-hook 'org-clock-in-hook (lambda () (dotfiles/silence (save-buffer))) t)
  (add-hook 'org-clock-out-hook (lambda () (dotfiles/silence (save-buffer))) t)

  ;; keep headlines when archiving tasks
  ;; http://orgmode.org/worg/org-hacks.html
  (with-eval-after-load 'org-archive
    (defadvice org-archive-subtree (around dotfiles/org-archive-subtree activate)
      (let ((org-archive-location
             (if (save-excursion (org-back-to-heading)
                                 (> (org-outline-level) 1))
                 (concat (car (split-string org-archive-location "::"))
                         "::* "
                         (s-join " - " (org-get-outline-path)))
               org-archive-location)))
        ad-do-it))
  )
)

(defun dotfiles-org/post-init-org-agenda ()
  (use-package org-agenda
    :defer t
    :config
    (evilified-state-evilify-map org-agenda-mode-map
      :mode org-agenda-mode
      :bindings

      ;; use T to cycle backwords through todo states
      (kbd "T") '(lambda () (interactive) (org-agenda-todo 'left))

                                          ; use o to open links
      (kbd "o") 'org-agenda-open-link

                                          ; jump to current clock entry
      (kbd "J") 'org-agenda-clock-goto

      ;; use uppercase letters to switch period
      (kbd "D") 'org-agenda-day-view
      (kbd "W") 'org-agenda-week-view
      (kbd "M") 'org-agenda-month-view
      (kbd "Y") 'org-agenda-year-view

      (kbd "d") 'org-agenda-deadline
      (kbd "s") 'org-agenda-schedule
      (kbd "w") 'org-save-all-org-buffers

      ;; restore normal line movements
      (kbd "^") 'evil-first-non-blank
      (kbd "0") 'evil-beginning-of-line
      (kbd "$") 'evil-end-of-line

      ;; these bindings from layers/+emacs/org somehow get lost
      (kbd "gd") 'org-agenda-toggle-time-grid
      (kbd "gr") 'org-agenda-redo
  )))

;; show calendar locations in agenda
(defun dotfiles-org/init-org-agenda-property ()
  (use-package org-agenda-property
    :defer t
    :config
    (setq org-agenda-property-list '("LOCATION"))))
