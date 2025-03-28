(use-package! pkl
  :mode "\.\(?:p\(?:cf\|kl\)\)\\'"
  :bind (:map pkl-mode-map
          ("C-c C-c" . compile)))
