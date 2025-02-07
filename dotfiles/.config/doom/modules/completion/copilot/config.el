;; -*- no-byte-compile: t; -*-
;;; completion/copilot/packages.el
(use-package! copilot
  :requires no-such-module
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
          ("<tab>"   . 'copilot-accept-completion)
          ("TAB"     . 'copilot-accept-completion)
          ("C-TAB"   . 'copilot-accept-completion-by-word)
          ("C-<tab>" . 'copilot-accept-completion-by-word)))
