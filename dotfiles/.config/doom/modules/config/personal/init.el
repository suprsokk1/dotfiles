(setq-default undo-limit 50
  fill-column 60)

(mkdir (expand-file-name "tmp" (getenv "XDG_RUNTIME_DIR")) t) ;FIXME /run/user/${UID}/tmp
(mkdir (expand-file-name "emacs" (getenv "XDG_RUNTIME_DIR")) t) ;FIXME /run/user/${UID}/tmp

(mapc #'(lambda (env)
          (setenv (symbol-name env))) '(SHELL
          TMUX_PANE TMUX
          GIT_DIR GIT_WORK_TREE))

(setenv "SHELL" "/bin/bash")

(setq
  doom-state-dir (expand-file-name "~/.local/doomemacs")
  doom-cache-dir  (expand-file-name "~/.cache/doomemacs")
  doom-profile-state-dir (expand-file-name "~/.local/doomemacs/profiles")
  doom-profile-cache-dir  (expand-file-name "~/.cache/doomemacs/profiles")
  split-window-preferred-function 'split-window-sensibly
  auto-hscroll-mode 'current-line
  custom-file "~/.custom.el"
  ;; `scroll' line; `not' window-buffer
  truncate-lines t
  ;; scroll-step 1
  ;; scroll-conservatively most-positive-fixnum
  scroll-conservatively 0
  vc-handled-backends '(git)
  default-input-method "norwegian-keyboard"
  delete-pair-blink-delay 0 ; NOTE skip animation (time compounds with each cursor)
  font-use-system-font nil
  initial-buffer-choice nil
  use-package-always-defer t
  compilation-scroll-output t
  flycheck-standard-error-navigation nil ; REVIEW
  ;; comint-output-filter-functions 'comint-truncate-buffer
  ;; comint-buffer-maximum-size 5000
  ;; comint-scroll-show-maximum-output t
  ;; comint-input-ring-size 500
  )

(make-directory doom-state-dir t)
(make-directory doom-cache-dir t)
(make-directory doom-profile-state-dir t)
(make-directory doom-profile-cache-dir t)
