(setq
  auto-hscroll-mode 'current-line

  ;; `scroll' line; `not' window-buffer
  truncate-lines t

  ;; scroll-step 1
  ;; scroll-conservatively most-positive-fixnum
  scroll-conservatively 0

  vc-handled-backends '(git)

  default-input-method "norwegian-keyboard"

  delete-pair-blink-delay 0 ; NOTE skip animation (time compounds with each cursor)

  display-line-numbers-type t

  font-use-system-font nil

  initial-buffer-choice nil

  use-package-always-defer t

  compilation-scroll-output t

  ;; comint-output-filter-functions 'comint-truncate-buffer
  ;; comint-buffer-maximum-size 5000
  ;; comint-scroll-show-maximum-output t
  ;; comint-input-ring-size 500

  )
