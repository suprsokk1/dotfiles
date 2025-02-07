
(use-package! emacs
  :hook (before-save . my/before-save)
  :bind
  (:map global-map
    ;; ("s-SPC s"    . )            ;TODO
    ;; ("s-/"           . keep-lines)
    ("s-/"           . consult-line)
    ("C-s"           . consult-line)
    ("s-i"           . ibuffer)
    ("s-x"           . eros-eval-defun)
    ("s-t"           . org-roam-tag-add)
    ("s-SPC 0"       . balance-windows)
    ("s-SPC s"       . my/narrow-to-region)
    ("s-SPC TAB"     . org-capture-goto-last-stored)
    ("s-r"           . consult-buffer)
    ("s-SPC s-SPC"   . execute-extended-command)
    ("s-SPC RET"     . consult-bookmark)
    ("s-SPC e"       . consult-flymake)
    ("s-SPC x"       . doom/switch-to-scratch-buffer)
    ("s-<backspace>" . delete-pair)
    ("s-n"           . my/split-window)
    ("M-s-n"         . split-window-vertically)
    ("s-k"           . delete-window)
    ("s-K"           . kill-buffer-and-window)
    ("M-s-k"         . doom/kill-this-buffer-in-all-windows)
    ("s-\\"          . indent-sexp)
    ("s-\["          . undo)
    ("s-\]"          . undo-redo)
    ("M-\["          . my/previous-error)
    ("M-\]"          . my/next-error)
    ;; ("C-;"        . my/yas-expand)
    ("s-SPC q"       . delete-other-windows)
    ("s-SPC t t"     . toggle-truncate-lines)
    ("s-SPC t r"     . rainbow-delimiters-mode)
    ("s-SPC n"       . my/org-capture)
    ("s-u"       . my/midnight-commander-window-swap))

  :init
  (defmacro my/unless-window (window-buffer &rest eval)
    `(unless (string-match ,window-buffer (format "%S" (window-list)))
       ,@eval))

  (defmacro my/when-window (window-buffer &rest eval)
    `(when (string-match ,window-buffer (format "%S" (window-list)))
       ,@eval))

  (defun my/midnight-commander-window-swap (&rest _)
    (interactive
      (windmove-swap-states-left)))

  (setq-default
    display-line-numbers-type nil
    ;; compile-command "make -k"
    truncate-lines-mode +1)

  (defun my/occur-level-1-headers (&rest _)
    (interactive (occur (rx bol ?* space))))

  (defun my/occur-level-1-headers-alt (&rest _)
    (interactive (save-window-excursion (occur (rx bol ?* space)))
      (next-error)))

  (defun my/split-window (&rest _)
    (interactive)
    (split-window-sensibly))

  (setq PIDFILE (expand-file-name "emacs/pid" (getenv "XDG_RUNTIME_DIR")))

  (defun my/write-pid-file (&rest _)
    (interactive)
    (let ((PIDFILE (expand-file-name "emacs/pid" (getenv "XDG_RUNTIME_DIR"))))
      (if (file-exists-p PIDFILE)
        (with-temp-buffer
          (setq-local buffer-file-name PIDFILE)
          (insert (format "%d" (emacs-pid)))
          (save-buffer)))))

  (defun my/eof (&rest _)
    (interactive)
    (bookmark-save)
    (let ((pid (file-exists-p PIDFILE)))
      (message "*** Config %s OK ***" (if pid "loaded" "reloaded")))
    (my/write-pid-file)
    (my/unless-window
      (split-window-sensibly) (org-agenda nil "t")))

  (setq my/compile-command-alist nil)
  :config

  (setq-hook! '(fundamental-mode)
    fill-column 3)

  (setq-hook! '(prog-mode org-mode yaml-mode)
    fill-column 60)

  (defun my/org-capture (&rest rest)
    (interactive
      (org-capture nil "ot")))

  (defun my/eof (&rest _)
    (interactive)
    (let ((PIDFILE (expand-file-name "emacs/pid" (getenv "XDG_RUNTIME_DIR"))))
      (if (file-exists-p PIDFILE)
        (progn
          (message "*** Config reloaded OK ***"))
        (progn
          (message "*** Config loaded ***"))
        (with-temp-buffer
          (setq-local buffer-file-name PIDFILE)
          (insert (format "%d" (emacs-pid)))
          (save-buffer))))
    (unless (string-match "agenda" (format "%S" (window-list))) (split-window-sensibly) (org-agenda nil "t")))

  (unless (member (expand-file-name "~/.local/bin") exec-path)
    (add-to-list 'exec-path (expand-file-name "~/.local/bin")))

  (unless (member (expand-file-name "~/bin") exec-path)
    (add-to-list 'exec-path (expand-file-name "~/bin")))

  (ignore-errors
    (load-file (expand-file-name "~/.lob.el"))
    (load-file (expand-file-name custom-file)))

  (mapc (lambda (_) (unless (member _ exec-path) (add-to-list 'exec-path _)))
    (file-expand-wildcards "~/opt/*/bin"))

  ;; TODO use system font
  (defmacro insert% (&rest EVAL)
    `(save-excursion (insert (format "\n%S" (progn ,@EVAL)))))

  (defun my/indent-right (&rest _)      ;FIXME
    (interactive
      (pcase major-mode
        ('python-mode
          (when (looking-at python-nav-beginning-of-defun-regexp)
            (mark-defun)
            (indent-rigidly-right-to-tab-stop (region-beginning) (region-end))))
        (_ nil))))

  (defun my/indent-left (&rest _)       ;FIXME
    (interactive
      (pcase major-mode
        ('python-mode
          (when (looking-at python-nav-beginning-of-defun-regexp)
            (mark-defun)
            (indent-rigidly-left-to-tab-stop (region-beginning) (region-end))))
        (_ nil))))

  (defun my/before-save (&rest _)
    ;; TODO (append-to-file START END FILENAME)
    (pcase major-mode
      ('emacs-lisp-mode nil)
      ('python-mode (when (member 'projectile-mode  minor-mode-list)
                      nil
                      ))
      ('sh-mode nil)
      (_ nil)))

  (defun my/ibuffer (&rest _)
    (interactive)
    (or (projectile-ibuffer ) (ibuffer)))

  (defun my/cmd (cmd)
    (interactive)
    (string-trim-right (shell-command-to-string cmd)))

  ;; (defalias )

  (defun my/yas-expand (&rest _)
    (interactive)
    (or (yas-expand) (message "fail: my/yas-expand")))

  (defun my/next-error (&rest _)
    (interactive)
    (if (eval `(string-match (rx 42 ,python-shell-buffer-name 42) (format "%S" (window-list))))
      (save-window-excursion
        (switch-to-buffer (get-buffer "*Python*"))
        (goto-char (buffer-end 1))
        (compile-goto-error))
      (or (flymake-goto-prev-error) (next-error))))

  (defun my/next-error (&rest _)
    (interactive)
    (pcase major-mode
      ('python-mode  (flymake-goto-next-error))
      (_ (next-error))))

  (defun my/previous-error (&rest _)
    (interactive)
    (pcase major-mode
      ('python-mode (flymake-goto-prev-error))
      (_ (previous-error))))

  (defun my/file-to-string (fname)
    (interactive)
    (with-temp-buffer (insert-file-contents-literally fname) (buffer-string)))

  (defmacro mktemp% (&rest REST)
    `(make-temp-file "emacs-" ,@REST))

  (defun my/window-buffers (&rest _)
    (interactive)
    (mapc  (window-list)))

  (defun my/emacsclient-helper (&rest _)
    (eval `(progn (save-window-excursion
                    (switch-to-buffer (get-buffer (window-buffer))
                      ,@_))))))

(use-package use-package-ensure-system-package)

(use-package! auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

(when (modulep! +org)
  (use-package! org
    ;; :defer 10
    :bind (:map global-map
            ("s-SPC a a" . my/org-agenda))
    :hook ((org-mode . my/org-mode) (org-babel-after-execute . ek/babel-ansi))
    :custom
    ;; (org-babel-load-languages nil)
    ;; (org-clone-delete-id nil)
    ;; (org-mode-hook nil)
    ;; (org-load-hook nil)
    ;; (org-log-buffer-setup-hook nil)
    ;; (org-modules nil)
    ;; (org-export-backends nil)
    ;; (org-support-shift-select nil)
    ;; (org-loop-over-headlines-in-active-region nil)
    ;; (org-startup-folded nil)
    ;; (org-startup-truncated nil)
    (org-startup-indented nil)
    ;; (org-startup-indented nil)
    ;; (org-startup-numerated nil)
    ;; (org-use-sub-superscripts nil)
    ;; (org-startup-with-beamer-mode nil)
    ;; (org-startup-align-all-tables nil)
    ;; (org-startup-shrink-all-tables nil)
    ;; (org-startup-with-inline-images nil)
    ;; (org-startup-with-latex-preview nil)
    ;; (org-insert-mode-line-in-empty-file nil)
    ;; (org-ellipsis nil)
    ;; (org-directory nil)
    ;; (org-default-notes-file nil)
    ;; (org-reverse-note-order nil)
    ;; (org-closed-keep-when-no-todo nil)
    ;; (org-indirect-buffer-display nil)
    ;; (org-file-appsorg-resource-download-policy nil)
    ;; (org-safe-remote-resources nil)
    ;; (org-open-non-existing-files nil)
    ;; (org-open-directory-means-index-dot-org nil)
    ;; (org-bookmark-names-plistorg-odd-levels-only nil)
    ;; (org-adapt-indentation nil)
    ;; (org-special-ctrl-a/e nil)
    ;; (org-special-ctrl-k nil)
    ;; (org-ctrl-k-protect-subtree nil)
    ;; (org-special-ctrl-o nil)
    ;; (org-yank-folded-subtrees nil)
    ;; (org-yank-adjusted-subtrees nil)
    ;; (org-M-RET-may-split-line nil)
    ;; (org-insert-heading-respect-content nil)
    ;; (org-blank-before-new-entry nil)
    ;; (org-insert-heading-hook nil)
    ;; (org-highlight-sparse-tree-matches nil)
    ;; (org-remove-highlights-with-change nil)
    ;; (org-occur-case-fold-search nil)
    ;; (org-occur-hook nil)
    ;; (org-self-insert-cluster-for-undo nil)
    ;; (org-highlight-links nil)
    ;; (org-mark-ring-length nil)
    ;; (org-todo-keywords nil)
    ;; (org-todo-interpretation nil)
    ;; (org-use-fast-todo-selection nil)
    ;; (org-provide-todo-statistics nil)
    ;; (org-hierarchical-todo-statistics nil)
    ;; (org-after-todo-state-change-hook nil)
    ;; (org-after-note-stored-hook nil)
    ;; (org-enforce-todo-dependencies nil)
    ;; (org-enforce-todo-checkbox-dependencies nil)
    ;; (org-treat-insert-todo-heading-as-state-change nil)
    ;; (org-treat-S-cursor-todo-selection-as-state-change nil)
    ;; (org-todo-state-tags-triggers nil)
    ;; (org-log-done nil)
    ;; (org-log-reschedule nil)
    ;; (org-log-redeadline nil)
    ;; (org-log-note-clock-out nil)
    ;; (org-log-done-with-time nil)
    ;; (org-log-note-headingsorg-log-into-drawer nil)
    ;; (org-log-state-notes-insert-after-drawers nil)
    ;; (org-log-states-order-reversed nil)
    ;; (org-todo-repeat-to-state nil)
    ;; (org-log-repeat nil)
    ;; (org-todo-repeat-hook nil)
    ;; (org-priority-enable-commands nil)
    ;; (org-priority-highest nil)
    ;; (org-priority-lowest nil)
    ;; (org-priority-default nil)
    ;; (org-priority-start-cycle-with-default nil)
    ;; (org-priority-get-priority-function nil)
    ;; (org-timestamp-rounding-minutes nil)
    ;; (org-display-custom-times nil)
    ;; (org-timestamp-custom-formatsorg-deadline-warning-days nil)
    ;; (org-scheduled-delay-days nil)
    ;; (org-read-date-prefer-future nil)
    ;; (org-agenda-jump-prefer-future nil)
    ;; (org-read-date-force-compatible-dates nil)
    ;; (org-read-date-display-live nil)
    ;; (org-read-date-popup-calendar nil)
    ;; (org-extend-today-until nil)
    ;; (org-use-effective-time nil)
    ;; (org-use-last-clock-out-time-as-effective-time nil)
    ;; (org-edit-timestamp-down-means-later nil)
    ;; (org-calendar-follow-timestamp-change nil)
    ;; (org-tag-alist nil)
    ;; (org-tag-persistent-alist nil)
    ;; (org-complete-tags-always-offer-all-agenda-tags nil)
    ;; (org-use-fast-tag-selection nil)
    ;; (org-fast-tag-selection-single-key nil)
    ;; (org-fast-tag-selection-maximum-tags nil)
    ;; (org-tags-column nil)
    ;; (org-auto-align-tags nil)
    ;; (org-use-tag-inheritance nil)
    (org-use-tag-inheritance t)
    ;; (org-tags-exclude-from-inheritance nil)
    ;; (org-tags-match-list-sublevels nil)
    ;; (org-tags-sort-function nil)
    ;; (org-property-format nil)
    ;; (org-properties-postprocess-alist nil)
    ;; (org-use-property-inheritance nil)
    (org-use-property-inheritance t)
    ;; (org-property-separators nil)
    ;; (org-columns-default-format nil)
    ;; (org-columns-default-format-for-agenda nil)
    ;; (org-columns-ellipses nil)
    ;; (org-global-properties nil)
    (org-agenda-files "~/.agenda")
    ;; (org-agenda-file-regexp nil)
    ;; (org-agenda-text-search-extra-files nil)
    ;; (org-agenda-skip-unavailable-files nil)
    ;; (org-format-latex-optionsorg-format-latex-signal-error nil)
    ;; (org-latex-to-mathml-jar-file nil)
    ;; (org-latex-to-mathml-convert-command nil)
    ;; (org-latex-to-html-convert-command nil)
    ;; (org-preview-latex-default-process nil)
    ;; (org-preview-latex-process-alistorg-preview-latex-image-directory nil)
    ;; (org-format-latex-header nil)
    ;; (org-latex-default-packages-alistorg-latex-packages-alist nil)
    ;; (org-level-color-stars-only nil)
    ;; (org-hide-leading-stars nil)
    ;; (org-hidden-keywords nil)
    ;; (org-custom-properties nil)
    ;; (org-fontify-todo-headline nil)
    ;; (org-fontify-done-headline nil)
    ;; (org-fontify-emphasized-text nil)
    ;; (org-fontify-whole-heading-line nil)
    ;; (org-fontify-whole-block-delimiter-line nil)
    ;; (org-highlight-latex-and-related nil)
    ;; (org-hide-emphasis-markers nil)
    ;; (org-hide-macro-markers nil)
    ;; (org-pretty-entities nil)
    ;; (org-pretty-entities-include-sub-superscripts nil)
    ;; ((Org <8.0) but allowing the users to nil)
    ;; (org-emphasis-alistorg-archive-locationorg-agenda-skip-archived-trees nil)
    ;; (org-columns-skip-archived-trees nil)
    ;; (org-sparse-tree-open-archived-trees nil)
    ;; (org-sparse-tree-default-date-type nil)
    ;; (org-group-tags nil)
    ;; (org-src-fontify-natively nil)
    ;; (org-allow-promoting-top-level-subtree nil)
    ;; (org-structure-template-alistorg-track-ordered-property-with-tag nil)
    ;; (org-image-actual-width nil)
    ;; (org-image-max-width nil)
    ;; (org-agenda-inhibit-startup nil)
    ;; (org-agenda-ignore-properties nil)
    ;; (org-display-remote-inline-images nil)
    ;; (org-image-align nil)
    ;; (org-yank-image-save-method nil)
    ;; (org-yank-image-file-name-function nil)
    ;; (org-yank-dnd-method nil)
    ;; (org-yank-dnd-default-attach-method nil)

  :config
  (setq org-babel-tangle-default-file-mode:shell 488
    org-babel-default-header-args
    (cons '(:noweb . "yes")
      (assq-delete-all :noweb
        (cons '(:results . "replace drawer")
          (assq-delete-all :results org-babel-default-header-args)))))

  (defun my/org-agenda (&rest _)
    (interactive (org-agenda nil "t")))

  (defun ek/babel-ansi ()
    "https://emacs.stackexchange.com/questions/44664/apply-ansi-color-escape-sequences-for-org-babel-results"
    (when-let ((beg (org-babel-where-is-src-block-result nil nil)))
      (save-excursion
        (goto-char beg)
        (when (looking-at org-babel-result-regexp)
          (let ((end (org-babel-result-end))
                 (ansi-color-context-region nil))
            (ansi-color-apply-on-region beg end))))))

  (defun my/reset-org-mode (&rest _)
    (interactive)
    (setq org-babel-default-header-args (default-value 'org-babel-default-header-args))
    (org-mode-restart))

  (defun my/org-mode (&rest _)
    (interactive)
    (unless (and truncate-lines (buffer-narrowed-p))
      (toggle-truncate-lines))
    (display-line-numbers-mode -1))))
