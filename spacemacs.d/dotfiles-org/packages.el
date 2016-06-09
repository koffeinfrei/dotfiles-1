(setq dotfiles-org-packages
 '(
   org
   org-indent
   (org-repo-todo :excluded t)
  ))

(defun dotfiles-org/post-init-org ()
  (setq
   org-directory "~/org"
   org-enforce-todo-dependencies t
   org-log-into-drawer t
   org-log-refile nil
   org-log-reschedule nil
   org-log-redeadline nil
   org-cycle-separator-lines 1
   org-refile-targets '((dotfiles/org-refile-targets :maxlevel . 2))
   org-refile-use-outline-path 'file
   org-refile-allow-creating-parent-nodes t
   org-outline-path-complete-in-steps nil
   org-startup-align-all-tables t
   org-startup-folded 'content
   org-startup-indented t
   org-todo-keywords
   '((sequence "TODO" "STARTED" "|" "DONE"))
   org-todo-keyword-faces
   '(("STARTED" . "#AE81FF")
     ("DONE" . org-special-keyword))
   org-tag-persistent-alist
   '(("work"   . ?w)
     ("events" . ?e))

   org-agenda-files '("~/org")
   org-agenda-buffer-name "*agenda*"
   org-agenda-window-setup 'only-window
   org-agenda-include-diary nil
   org-agenda-clockreport-parameter-plist '(:link t :maxlevel 5)

   org-agenda-custom-commands
   '(
     ("h" "Home context"
      ((agenda ""))
      ((org-agenda-tag-filter-preset '("-work"))))
     ("w" "Work context"
      ((agenda ""))
      ((org-agenda-tag-filter-preset '("+work"))))
     ("g" "GTD workflow"
      ((todo "STARTED")
       (todo "TODO")))
    )

   org-clock-history-length 25
   org-clock-in-resume t
   org-clock-out-remove-zero-time-clocks t
   org-clock-persist t

   org-capture-templates
   '(
     ("t" "Todo" entry (file+headline "todo.org" "Inbox")
      "* TODO %?")
     ("w" "Work" entry (file+headline "work.org" "Inbox")
      "* TODO %?")
    )
  )

  (with-eval-after-load 'org
    (add-to-list 'org-modules 'org-habit)
    (org-clock-persistence-insinuate))

  (with-eval-after-load 'org-agenda
    (define-key org-agenda-mode-map (kbd "C-w") 'evil-window-map)
    (define-key org-agenda-mode-map (kbd "C-h") 'evil-window-left)
    (define-key org-agenda-mode-map (kbd "C-j") 'evil-window-down)
    (define-key org-agenda-mode-map (kbd "C-k") 'evil-window-up)
    (define-key org-agenda-mode-map (kbd "C-l") 'evil-window-right)

    (define-key org-agenda-mode-map (kbd "D") 'org-agenda-day-view)
    (define-key org-agenda-mode-map (kbd "W") 'org-agenda-week-view)
    (define-key org-agenda-mode-map (kbd "M") 'org-agenda-month-view)
    (define-key org-agenda-mode-map (kbd "Y") 'org-agenda-year-view)

    (define-key org-agenda-mode-map (kbd "w") 'org-save-all-org-buffers)
  )

  (add-hook 'org-capture-mode-hook 'evil-insert-state)
  (add-hook 'org-clock-in-hook 'dotfiles/org-start-task)

  (when (executable-find "hamster")
    (add-hook 'org-clock-in-hook 'dotfiles/org-start-hamster-task)
    (add-hook 'org-clock-out-hook 'dotfiles/org-stop-hamster-task))

  ;; keep headlines when archiving tasks
  ;; http://orgmode.org/worg/org-hacks.html
  (with-eval-after-load 'org-archive
    (defadvice org-archive-subtree (around dotfiles/org-archive-subtree activate)
      (let ((org-archive-location
             (if (save-excursion (org-back-to-heading)
                                 (> (org-outline-level) 1))
                 (concat (car (split-string org-archive-location "::"))
                         "::* "
                         (car (org-get-outline-path)))
               org-archive-location)))
        ad-do-it))
  )
)
