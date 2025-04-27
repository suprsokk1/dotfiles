;;; ${DOOMDIR}/config.el -*- no-byte-compile: t -*-

(shell-command "chmod -R u=rwX,go= /var/run/*/emacs")                                 ;FIXME

(setq consult-ripgrep-args "rg --null --line-buffered --color=never --max-columns=1000 --path-separator / --smart-case --no-heading --with-filename --line-number --search-zip")

(map! "M-s-\[" 'winner-undo
  "M-S-\]" 'winner-redo)

(use-package! ibuffer
  :bind (("s-i" . ibuffer)
          (:map ibuffer-mode-map
            ("q" . nil)))
  :hook (ibuffer-mode . (lambda () (ibuffer-switch-to-saved-filter-groups "default")))
  :custom
  (ibuffer-expert nil)
  (ibuffer-saved-filter-groups `(("default"
                                   ("dired" (mode . dired-mode))
                                   ("org-roam" (name . ,(rx "20" (repeat 13 digit) ?. "org" eol)))
                                   ("magit" (name . "^magit"))
                                   ("ein" (name . "^\\*ein:"))
                                   ("pkl" (mode . pkl-mode))
                                   ("planner" (or
                                                (name . "^\\*Calendar\\*$")
                                                (name . "^\\*Org Agenda\\*")))
                                   ("emacs" (or
                                              (name . "^\\*scratch\\*$")
                                              (name . "^\\*Messages\\*$")))))))

(after! yasnippet
  (setq +snippets-dir "~/.local/share/doom/snippets"))

(after! projectile
  (map! :map projectile-mode-map
    "s-p p"   'projectile-switch-project
    "s-p s-p" 'projectile-find-file))

(after! dired
  (map! ("s-l" 'dired-jump)
    (:map dired-mode-map
      ("s-l" 'self-insert-command))))

(after! org
  (setq org-return-follows-link t)
  (setq org-babel-default-header-args
    (cons '(:noweb . "yes")
      (assq-delete-all :noweb org-babel-default-header-args)))
  (setq org-babel-default-header-args
    (cons '(:results . "drawer")
      (assq-delete-all :results org-babel-default-header-args))))

(after! lisp
  (map! :map emacs-lisp-mode-map
    "C-c C-c" 'eval-buffer))

(use-package! ein
  :after ibuffer
  :custom
  (ein:output-area-inlined-images t)
  :config
  (set-popup-rule! "^\\*ein:" :ignore t))
