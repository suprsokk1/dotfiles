;;; ui/writeroom/config.el -*- lexical-binding: t; -*-
(use-package! writeroom-mode
  :custom
  (writeroom-width 100)

  (writeroom-added-width-left(if (>= emacs-major-version 26)
                               #'writeroom-full-line-number-width
                               0))
  (writeroom-global-effects '(writeroom-set-fullscreen
                              writeroom-set-alpha
                              writeroom-set-menu-bar-lines
                              writeroom-set-tool-bar-lines
                              writeroom-set-vertical-scroll-bars
                              writeroom-set-bottom-divider-width))
  (writeroom-local-effects nil))
