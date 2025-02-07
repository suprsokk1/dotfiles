;;; ui/origami/config.el -*- lexical-binding: t; -*-
(use-package! pkl
  :mode "\.\(?:p\(?:cf\|kl\)\)\\'"
  :hook (pkl-mode . my/pkl-mode)
  :bind (:map pkl-mode-map
          ("C-c C-c" . compile))
  :config
  (defun my/pkl-mode (&rest _)
    (interactive)
    (setq-local compile-command
      (concat "~/.local/bin/pkl eval " (buffer-name)))))
