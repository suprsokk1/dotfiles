(setq-default undo-limit 50
  fill-column 60)

(let ((tmp (expand-file-name "tmp" (getenv "XDG_RUNTIME_DIR")))
       (emacs (expand-file-name "emacs" (getenv "XDG_RUNTIME_DIR"))))
  (mkdir tmp t) ;FIXME /run/user/${UID}/tmp
  (mkdir emacs t) ;FIXME /run/user/${UID}/tmp
  (chmod emacs 0700))


(quote `(mapc #'(lambda (env)
                  (setenv (symbol-name env))) '(SHELL
                  TMUX_PANE TMUX
                  GIT_DIR GIT_WORK_TREE)))

(setenv "SHELL" "/bin/bash")

(setq
  doom-state-dir  (expand-file-name "~/.local/doomemacs")
  doom-cache-dir  (expand-file-name "~/.cache/doomemacs")
  doom-profile-state-dir (expand-file-name "~/.local/doomemacs/profiles")
  doom-profile-cache-dir  (expand-file-name "~/.cache/doomemacs/profiles")
  split-window-preferred-function 'split-window-sensibly
  custom-file "~/.custom.el"

  vc-handled-backends '(git)
  default-input-method "norwegian-keyboard"
  delete-pair-blink-delay 0 ; NOTE skip animation (time compounds with each cursor)
  font-use-system-font nil
  initial-buffer-choice nil
  use-package-always-defer t
  compilation-scroll-output t

  ;; comint-output-filter-functions 'comint-truncate-buffer
  ;; comint-buffer-maximum-size 5000
  ;; comint-scroll-show-maximum-output t
  ;; comint-input-ring-size 500
  )

(when (modulep! +linescroll)
  (setq
    auto-hscroll-mode 'current-line
    ;; `scroll' line; `not' window-buffer
    truncate-lines t
    ;; scroll-step 1
    ;; scroll-conservatively most-positive-fixnum
    scroll-conservatively 0))

(when (modulep! +perftweaks)
  (setq flycheck-standard-error-navigation nil))  ; REVIEW

(make-directory doom-state-dir t)
(make-directory doom-cache-dir t)
(make-directory doom-profile-state-dir t)
(make-directory doom-profile-cache-dir t)

(defmacro my/unless-window (window-buffer &rest eval)
  `(unless (string-match ,window-buffer (format "%S" (window-list)))
     ,@eval))

(defmacro my/when-window (window-buffer &rest eval)
  `(when (string-match ,window-buffer (format "%S" (window-list)))
     ,@eval))

(defun my/midnight-commander-window-swap (&rest _)
  (interactive
    (windmove-swap-states-left)))

(defun my/occur-level-1-headers (&rest _)
  (interactive (occur (rx bol ?* space))))

(defun my/occur-level-1-headers-alt (&rest _)
  (interactive (save-window-excursion (occur (rx bol ?* space)))
    (next-error)))

(defun my/split-window (&rest _)
  (interactive)
  (split-window-sensibly))

(defun my/write-pid-file (&rest _)
  (interactive)
  (let ((PIDFILE (expand-file-name "emacs/pid" (getenv "XDG_RUNTIME_DIR"))))
    (if (file-exists-p PIDFILE)
      (with-temp-buffer
        (setq-local buffer-file-name PIDFILE)
        (insert (format "%d" (emacs-pid)))
        (save-buffer)))))

(defun my/eof (&rest _)
  (interactive)
  (bookmark-save)
  (let ((pid (file-exists-p PIDFILE)))
    (message "*** Config %s OK ***" (if pid "loaded" "reloaded")))
  (my/write-pid-file)
  (my/unless-window
    (split-window-sensibly) (org-agenda nil "t")))

(setq my/compile-command-alist nil)
