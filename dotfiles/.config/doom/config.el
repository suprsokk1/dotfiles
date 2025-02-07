;;; ${DOOMDIR}/config.el -*- no-byte-compile: t -*-

(after! prog-mode
  (setq-hook! 'prog-mode-hook
    display-line-numbers-type 'absolute
    display-line-numbers-mode +1))

(after! python
  (setq-hook! '(inferior-python-mode-hook)
    window-point-insertion-type t)

  (setq python-flymake-command '("ruff" "--quiet" "--stdin-filename=stdin" "-"))

  (defun my/python-run (&optional retry)
    (interactive)
    (my/unless-window python-shell-buffer-name
      (+eval/open-repl-other-window))
    (python-shell-send-file (buffer-file-name))))

(use-package! python
  :hook (python-base-mode . flymake-mode)
  :bind (:map python-mode-map
          ("M-`"          . consult-flymake)
          ;; ("s-SPC s-SPC"  . consult-flymake)
          ("s-SPC s-SPC"  . consult-compile-error)
          ("C-c C-c"      . my/python-run)
          ("C-c C-r"      . python-shell-restart)
          ("C-c C-e"      . python-shell-send-defun))
  )


(use-package! eldoc-box
  :config
  (add-hook 'eglot-managed-mode-hook #'eldoc-box-hover-mode t)
  ;; (remove-hook 'eglot-managed-mode-hook #'eldoc-box-hover-mode t)
  )

(use-package! ibuffer
  :after python
  :hook (ibuffer . (lambda () (ibuffer-switch-to-saved-filter-groups "default")))
  :config
  ;; (highlight-regexp (rx ))

  ; https://tech.tonyballantyne.com/2020/09/26/ibuffer-changed-my-life/
  ;; (setq ibuffer-expert t) ; stop yes no prompt on delete
  (setq ibuffer-saved-filter-groups
	  `(quote (("default"
		           ("dired" (mode . dired-mode))
		           ("org-roam" (mode . org-roam-mode))
	             ("org" (mode . org-mode))
		           ("magit" (name . "^magit"))
               ("python" (or
				                   (mode . python-mode)
				                   (name . ,(format "^\\*%s\\*" python-shell-buffer-name))))
		           ("planner" (or
				                    (name . "^\\*Calendar\\*$")
				                    (name . "^\\*Org Agenda\\*")))
		           ("emacs" (or
			                    (name . "^\\*scratch\\*$")
			                    (name . "^\\*Messages\\*$")))))))

  ;; (add-hook 'ibuffer-mode-hook
	;;   (lambda () (ibuffer-switch-to-saved-filter-groups "default")))
  )

(use-package! winner
  :bind
  (:map winner-mode-map
    ("M-s-\[" . winner-undo)
    ("M-s-\]" . winner-redo)))

(use-package! multiple-cursors
  :bind
  (:map global-map
    ("s-SPC r"    . mc/mark-all-in-region-regexp)
    ("s-SPC m r"  . mc/mark-all-in-region-regexp)
    ("s-SPC m w"  . mc/mark-all-in-region-regexp)
    ("s-."        . mc/mark-all-dwim)
    ("C-."        . mc/mark-next-like-this)))

(use-package! windmove
  :bind (:map global-map
          ("M-s-q" . windmove-swap-states-left)
          ("M-s-w" . windmove-swap-states-up)
          ("M-s-e" . windmove-swap-states-right)
          ("M-s-s" . windmove-swap-states-down)
          ("s-q"   . windmove-left)
          ("s-w"   . windmove-up)
          ("s-e"   . windmove-right)
          ("s-s"   . windmove-down)))

(use-package! dired
  :bind (:map global-map
          ("s-l" . dired-jump)
          :map dired-mode-map
          ("r"   . dired-do-rename-regexp)
          ("/"   . dired-mark-files-regexp)))

(use-package! projectile
  :hook (prog-mode . projectile-mode)
  :config
  (setq projectile-indexing-method 'alien)
  :custom
  (projectile-switch-project-action 'my/projectile-switch-project-action)
  :bind-keymap (("s-SPC p" . projectile-command-map)
                 ("s-p"    . projectile-command-map))
  :init   (when (file-directory-p "~/Projects")
            (setq projectile-project-search-path '("~/Projects")))
  :bind (:map projectile-mode-map
          ("s-p s"       . '+default/search-project)
          ("s-p s-p"     . 'projectile-recentf)
          ("s-p p"       . 'project-switch-project)
          ;; ("s-SPC ."  . +default/search-notes-for-symbol-at-point)
          ("s-p ."       . '+default/search-project-for-symbol-at-point)
          ("s-SPC ."     . '+default/search-project-for-symbol-at-point)))

(use-package! lisp
  :mode "\.\(?:el\|projectile\)\\'" ; (insert (concat (rx 10 34) (rx (* any) ?. (or "projectile" "el")) (rx 92) (rx 39) (rx 34)))
  :init
  :bind (:map emacs-lisp-mode-map
          ("C-c C-c" . eval-buffer)))

(use-package flymake-ruff
  :hook (python-mode . flymake-ruff-load))

(use-package! eglot
  :config
  (setq
    read-process-output-max (* 1024 1024) ; 1mb
    lsp-log-io nil                  ; if set to true can cause a performance hit
    lsp-disabled-clients '(mspyls pylsp pyls)))

(use-package! org-roam
  :bind ((:map global-map
           ("s-SPC SPC" . org-roam-node-find))
          (:map org-roam-mode-map
            ("s-t" . org-roam-tag-add))))

(use-package! magit
  :bind (:map global-map
          ("s-g" . magit-status)))

(after! sh-mode
  (setq-hook! 'sh-mode-hook compile-command (concat "bash" " " (buffer-file-name))))

(use-package! sh-mode
  :init

  :bind (:map sh-mode-map))

(after! yasnippet
  (setq +snippets-dir (expand-file-name "~/Templates/emacs/snippets")))

(use-package! yasnippet
  :hook ((prog-mode sh-mode) . yas-minor-mode))

(use-package! vterm
  :bind (:map global-map
          ("s-SPC \\" . vterm-other-window)))

(use-package! tree-sitter
  :config
  (setq +tree-sitter-hl-enabled-modes '(emacs-lisp-mode go-mode)))

(use-package! corfu
  :custom
  (corfu-auto-delay .3))
