;; -*- mode: emacs-lisp -*-
;;
;; FIXME:
;; - continue comment on newline
;; - complete with TAB instead of RET?
;; - colors in terminal mode
;; - detection of sh/bash files
;;
;; TODO:
;; - setup tabbar
;; - setup shells
;; - grunt integration
;;

(setq is-gui    (display-graphic-p))
(setq is-ocelot (string= system-name "ocelot"))

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load. If it is the symbol `all' instead
   ;; of a list then all discovered layers will be installed.
   dotspacemacs-configuration-layer-path '("~/.spacemacs.d")
   dotspacemacs-configuration-layers
   '(
     ;; configuration
     better-defaults
     (theming
      :variables
      theming-headings-inherit-from-default 'all
      theming-headings-same-size 'all
      theming-headings-bold 'all)

     ;; vim
     unimpaired
     vim-empty-lines

     ;; development
     auto-completion
     syntax-checking
     version-control
     github
     git

     ;; apps
     org
     dash
     (ranger
      :variables
      ranger-show-dotfiles nil)
     (shell
      :variables
      shell-default-height 30
      shell-default-position 'bottom)

     ;; languages
     elixir
     elm
     emacs-lisp
     erlang
     html
     javascript
     lua
     markdown
     php
     python
     ruby
     shell-scripts
     yaml
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages
   '(
     simpleclip
     tabbar-ruler

     dracula-theme
     gotham-theme
     leuven-theme
     moe-theme
     molokai-theme
     monokai-theme
     subatomic-theme
    )
   ;; A list of packages and/or extensions that will not be install and loaded.
   dotspacemacs-excluded-packages
   '(
     smooth-scrolling
    )
   ;; If non-nil spacemacs will delete any orphan packages, i.e. packages that
   ;; are declared in a layer which is not a member of
   ;; the list `dotspacemacs-configuration-layers'. (default t)
   dotspacemacs-delete-orphan-packages t))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   dotspacemacs-elpa-timeout 5
   ;; If non nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. (default t)
   dotspacemacs-check-for-update t
   ;; One of `vim', `emacs' or `hybrid'. Evil is always enabled but if the
   ;; variable is `emacs' then the `holy-mode' is enabled at startup. `hybrid'
   ;; uses emacs key bindings for vim's insert mode, but otherwise leaves evil
   ;; unchanged. (default 'vim)
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official
   ;; List of items to show in the startup buffer. If nil it is disabled.
   ;; Possible values are: `recents' `bookmarks' `projects'.
   ;; (default '(recents projects))
   dotspacemacs-startup-lists '(recents projects bookmarks)
   ;; Number of recent files to show in the startup buffer. Ignored if
   ;; `dotspacemacs-startup-lists' doesn't include `recents'. (default 5)
   dotspacemacs-startup-recent-list-size 10
   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(monokai)
   ;; If non nil the cursor color matches the state color in GUI Emacs.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font. `powerline-scale' allows to quickly tweak the mode-line
   ;; size to make separators look not too crappy.
   dotspacemacs-default-font '("Source Code Pro"
                               :size 13
                               :weight normal
                               :width normal
                               :powerline-scale 1.0)
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m)
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs C-i, TAB and C-m, RET.
   ;; Setting it to a non-nil value, allows for separate commands under <C-i>
   ;; and TAB or <C-m> and RET.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil
   ;; (Not implemented) dotspacemacs-distinguish-gui-ret nil
   ;; The command key used for Evil commands (ex-commands) and
   ;; Emacs commands (M-x).
   ;; By default the command key is `:' so ex-commands are executed like in Vim
   ;; with `:' and Emacs commands are executed with `<leader> :'.
   dotspacemacs-command-key ":"
   ;; If non nil `Y' is remapped to `y$'. (default t)
   dotspacemacs-remap-Y-to-y$ t
   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"
   ;; If non nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil
   ;; If non nil then the last auto saved layouts are resume automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache
   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5
   ;; If non nil then `ido' replaces `helm' for some commands. For now only
   ;; `find-files' (SPC f f), `find-spacemacs-file' (SPC f e s), and
   ;; `find-contrib-file' (SPC f e c) are replaced. (default nil)
   dotspacemacs-use-ido nil
   ;; If non nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize t
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-micro-state t
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup is-ocelot
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols nil
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters the
   ;; point when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling nil
   ;; If non nil line numbers are turned on in all `prog-mode' and `text-mode'
   ;; derivatives. If set to `relative', also turns on relative line numbers.
   ;; (default nil)
   dotspacemacs-line-numbers t
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil advises quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   ;; (default '("ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed'to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."

  (setq-default

   ;; indentation
   tab-width 2
   evil-shift-width 2
   c-basic-offset 2
   css-indent-offset 2
   erlang-indent-level 2
   js-indent-level 2
   js2-basic-offset 2
   jsx-indent-level 2
   sh-indentation 2
   sh-basic-offset 2
   web-mode-markup-indent-offset 2
   web-mode-code-indent-offset 2
   web-mode-css-indent-offset 2
   web-mode-attr-indent-offset 2

   ;; emacs settings
   require-final-newline t
   resize-mini-windows t

   ;; work around laggy smooth-scrolling layer
   ;; https://github.com/syl20bnr/spacemacs/issues/1781
   scroll-step 1
   scroll-margin 5
   scroll-conservatively 0
   scroll-up-aggressively 0.01
   scroll-down-aggressively 0.01
   mouse-wheel-scroll-amount '(1 ((shift) . 1))
   mouse-wheel-progressive-speed t
   mouse-wheel-follow-mouse t

   ;; evil settings
   evil-cross-lines t
   evil-escape-delay 0
   evil-ex-interactive-search-highlight 'selected-window
   evil-split-window-below t
   evil-vsplit-window-right t

   ;; package settings
   exec-path-from-shell-check-startup-files nil
   flycheck-check-syntax-automatically '(mode-enabled save)
   magit-repository-directories '("~/src")
   powerline-height (if is-ocelot 28 16)
   ruby-version-manager 'rbenv
   vc-follow-symlinks t

   ;; theme settings
   theming-modifications
   '((monokai
      ;; modeline
      (spacemacs-normal-face :background "#A6E22E" :foreground "#344D05")
      (spacemacs-visual-face :background "#FD971F" :foreground "#663801")
      (spacemacs-insert-face :background "#66D9EF" :foreground "#1D5A66")

      ;; line numbers
      (linum :background "#12120F" :foreground "#45453A")

      ;; visual selection
      ;; (region :inherit nil :background "#0E3436")
      (region :inherit nil :background "#000" :bold t)

      ;; cursorline
      (hl-line :background "#33332B")
      (trailing-whitespace :background "#404035")

      ;; search highlighting
      (isearch :background "#D3FBF6" :foreground "black" :bold t)
      (lazy-highlight :background "#74DBCD" :foreground "black")
      (evil-search-highlight-persist-highlight-face
       :background "#74DBCD" :foreground "black")

      ;; comments
      (font-lock-comment-face :foreground "#99937A")
      (font-lock-comment-delimiter-face :foreground "#99937A")
      (font-lock-doc-face :foreground "#40CAE4")

      ;; error symbols
      (flycheck-fringe-error :background nil)
      (flycheck-fringe-warning :background nil)
      (flycheck-fringe-info :background nil)
    ))
  )

  ;; Set default size of new windows
  (add-hook 'before-make-frame-hook
            #'(lambda ()
                (add-to-list 'default-frame-alist '(width  . 120))
                (add-to-list 'default-frame-alist '(height . 60))))
  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."

  ;; Override Spacemacs settings
  (setq-default
   linum-format "%5d "
  )

  ;; Enable flycheck for additional filetypes
  (spacemacs/add-flycheck-hook 'shell-mode-hook)

  ;; show file and project in title
  ;; https://github.com/syl20bnr/spacemacs/pull/5924
  (defun spacemacs//frame-title-format ()
    "Return frame title with current project name, where applicable."
    (let ((file buffer-file-name))
      (concat "emacs: "
        (cond
        ((eq nil file) "%b")
        ((and (bound-and-true-p projectile-mode)
              (projectile-project-p))
          (concat (substring file (length (projectile-project-root)))
                  (format " [%s]" (projectile-project-name))))
        (t (abbreviate-file-name file))))))

  ;; auto-open error list
  (defun flycheck-auto-list-errors ()
    (if flycheck-current-errors
      (flycheck-list-errors)
      (-if-let (window (flycheck-get-error-list-window))
        (quit-window nil window))))
  (add-hook 'flycheck-after-syntax-check-hook 'flycheck-auto-list-errors)

  (when is-gui
    (setq frame-title-format '((:eval (spacemacs//frame-title-format)))))

  ;; paste with Ctrl-v, quoted insert with Ctrl-q
  (simpleclip-mode t)
  (global-set-key (kbd "C-v") 'simpleclip-paste)
  (define-key evil-normal-state-map (kbd "C-v") 'simpleclip-paste)
  (define-key evil-insert-state-map (kbd "C-v") 'simpleclip-paste)
  (define-key evil-visual-state-map (kbd "C-v") 'simpleclip-paste)

  (global-set-key (kbd "C-q") 'quoted-insert)
  (define-key evil-insert-state-map (kbd "C-q") 'quoted-insert)

  ;; always focus new splits
  (spacemacs/set-leader-keys
    "ws" 'split-window-below-and-focus
    "wS" 'split-window-below
    "wv" 'split-window-right-and-focus
    "wV" 'split-window-right)

  ;; yank linewise with Y
  (define-key evil-normal-state-map (kbd "Y") (kbd "yy"))

  ;; navigate windows with Ctrl-h/j/k/l
  (global-set-key (kbd "C-h") 'evil-window-left)
  (global-set-key (kbd "C-j") 'evil-window-down)
  (global-set-key (kbd "C-k") 'evil-window-up)
  (global-set-key (kbd "C-l") 'evil-window-right)
  (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
  (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
  (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)

  ;; readline keys in insert mode
  (define-key evil-insert-state-map (kbd "C-a") 'beginning-of-line)
  (define-key evil-insert-state-map (kbd "C-e") 'end-of-line)

  ;; cycle numbers with Ctrl-a/z
  (define-key evil-normal-state-map (kbd "C-a") 'evil-numbers/inc-at-pt)
  (define-key evil-normal-state-map (kbd "C-z") 'evil-numbers/dec-at-pt)

  ;; Helm bindings
  (with-eval-after-load 'helm
    (define-key helm-map (kbd "C-w") 'backward-kill-word))

  ;; show file name with Ctrl-g
  (global-set-key (kbd "C-g")
                  (lambda ()
                    (interactive)
                    (message "%s" (or (buffer-file-name) (buffer-name)))))

  ;; emulate Ctrl-u behaviour from Vim
  ;; TODO: try deleting only newly entered characters first
  ;; TODO: submit upstream bug report
  (define-key evil-insert-state-map (kbd "C-u") 'backward-kill-line)
  (defun backward-kill-line ()
    (interactive)
    (let ((end (point)))
      (evil-beginning-of-line)
      (unless (looking-at "[[:space:]]*$")
        (evil-first-non-blank))
      (delete-region (point) end)))

  ;; duplicate selected region
  (define-key evil-visual-state-map (kbd "D") 'duplicate-region)
  (defun duplicate-region ()
    (interactive)
    (let* ((end (region-end))
           (text (buffer-substring (region-beginning)
                                   end)))
      (goto-char end)
      (insert text)
      (push-mark end)
      (setq deactivate-mark nil)
      (exchange-point-and-mark)))

  ;; C-c as general purpose escape key sequence.
  ;; https://www.emacswiki.org/emacs/Evil#toc16
  (defun escape-anywhere (prompt)
    ;; Clear search highlight
    (evil-search-highlight-persist-remove-all)

    ;; Copy region to clipboard
    (when (and evil-mode (eq evil-state 'visual))
      (evil-visual-expand-region)
      (simpleclip-copy evil-visual-beginning evil-visual-end))

    "Functionality for escaping generally.  Includes exiting Evil insert state and C-g binding. "
    (cond
    ;; If we're in one of the Evil states that defines [escape] key, return [escape] so as
    ;; Key Lookup will use it.
    ((or (evil-insert-state-p) (evil-normal-state-p) (evil-replace-state-p) (evil-visual-state-p)) [escape])
    ;; This is the best way I could infer for now to have C-c work during evil-read-key.
    ;; Note: As long as I return [escape] in normal-state, I don't need this.
    ;;((eq overriding-terminal-local-map evil-read-key-map) (keyboard-quit) (kbd ""))
    (t (kbd "C-g"))))
  (define-key key-translation-map (kbd "C-c") 'escape-anywhere)
  ;; Works around the fact that Evil uses read-event directly when in operator state, which
  ;; doesn't use the key-translation-map.
  (define-key evil-operator-state-map (kbd "C-c") 'keyboard-quit)

  ;; (require 'tabbar-ruler)
  ;; (tabbar-ruler-style-firefox)
  ;; (tabbar-ruler-group-by-projectile-project)
  ;; (setq
  ;;  tabbar-ruler-global-tabbar t
  ;;  tabbar-ruler-fancy-current-tab-separator 'wave
  ;;  tabbar-ruler-fancy-tab-separator 'wave
  ;;  tabbar-ruler-tab-height powerline-height
  ;;  tabbar-ruler-tab-padding nil
  ;;  tabbar-ruler-pad-selected nil
  ;;  tabbar-ruler-padding-face nil
  ;;  )

  ;; (dolist (face '(tabbar-button
  ;;                 tabbar-separator
  ;;                 tabbar-selected
  ;;                 tabbar-selected-highlight
  ;;                 tabbar-selected-modified
  ;;                 tabbar-unselected
  ;;                 tabbar-unselected-highlight
  ;;                 tabbar-unselected-modified))
  ;;   (set-face-attribute face nil :height 80)
  ;;   (set-face-bold face nil))
  ;; (dolist (face '(tabbar-selected
  ;;                 tabbar-selected-highlight))
  ;;   (set-face-foreground face "#fff"))
  ;; (dolist (face '(tabbar-unselected
  ;;                 tabbar-unselected-highlight))
  ;;   (set-face-foreground face "#aaa"))
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
