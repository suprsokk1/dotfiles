;;; ui/origami/config.el -*- lexical-binding: t; -*-
(use-package! pkl
  :mode "\.\(?:p\(?:cf\|kl\)\)\\'"
  :bind (:map pkl-mode-map
          ("C-c C-c" . compile))
  :config
	(setq-hook! 'pkl-mode
			compile-command (concat "~/.local/bin/pkl eval " (buffer-name))))
