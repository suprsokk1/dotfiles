;;; $DOOMDIR/init.el  -*- no-byte-compile: t -*-
(doom!
  :lang
  pkl
  (org +roam2 +pandoc)
  (python +pyright +pyenv +poetry +lsp)
  (yaml +tree-sitter)
  (sh +lsp)
  :tools
  editorconfig
  magit
  tmux
  direnv
  debugger
  tree-sitter
  ein
  (eval +overlay)
  (lsp +eglot)
  (ansible +lsp)
  :checkers
  (syntax +childframe +flymake +icons)
  :completion
  (vertico +childframe +icons)
  (corfu +icons +orderless +dabbrev)
  :emacs
  undo
  (dired +dirvish +icons)
  :ui treemacs hl-todo rainbow-delimiters
  (emoji +ascii +github +unicode)
  (popup +defaults +all)
  (vc-gutter +diff-hl +pretty)
  (modeline +light)
  (ligatures +extra +iosevka)
  (custom-ligatures +ubuntu)
  :editor
  multiple-cursors
  snippets
  ;; format
  :config
  (default +bindings)
  (personal +bindings)
  :term vterm
  :themes
  (catppuccin +mocha)
  :advice compile-command)
