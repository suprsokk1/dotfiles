(setenv "TMPDIR" (expand-file-name "tmp" (getenv "XDG_RUNTIME_DIR")))


(doom!
  :config
  (default +bindings)

  :checkers
  (syntax +childframe +flymake +icons)

  :completion
  (vertico +childframe +icons)
  (corfu +icons +orderless +dabbrev)

  :editor
  multiple-cursors
  snippets

  :emacs
  (dired +icons)
  undo

  :lang
  (org +pomodoro +roam2 +pandoc)
  ;; (python +lsp +pyright)
  ;; (yaml +lsp)
  (python +tree-sitter +pyenv)
  (yaml +tree-sitter)

  :ui
  (vc-gutter +diff-hl +pretty)
  (modeline +light)
  hl-todo
  (treemacs)

  :tools
  (eval +overlay)
  (lsp +eglot)
  (tree-sitter)
  ansible
  direnv
  editorconfig
  magit
  tmux

  :term
  vterm)
