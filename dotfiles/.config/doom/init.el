;;; $DOOMDIR/init.el  -*- no-byte-compile: t -*-
(doom!
  :lang
  pkl
  (org +roam2 +pandoc)
  (python +pyright +conda +pyenv +poetry +lsp)
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
  (dired +icons)
  :ui
  treemacs
  hl-todo
  rainbow-delimiters
  (emoji +ascii +github +unicode)
  (popup +defaults +all)
  (vc-gutter +diff-hl +pretty)
  (modeline +light)
  (ligarure +extra +iosevka)
  (custom-ligatures +ubuntu)
  :term vterm
  :editor
  multiple-cursors
  snippets
  ;; format
  :config
  (default +bindings)
  (personal +perftweaks +linescroll)
  (bindings +global)
  :themes (catppuccin +mocha)
  ;; :advice compile-command
  )
