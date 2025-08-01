;; [[file:config.org::*org-roam][org-roam:1]]
(after! (:and org-roam expand-region)
  (defun advice/before--org-roam-node-insert (&rest rest)
    (when-let (($ (symbol-at-point)))
      (er/mark-symbol)))
  (advice-remove 'org-roam-node-insert #'advice/before--org-roam-node-insert)
  (advice-add 'org-roam-node-insert :before #'advice/before--org-roam-node-insert))

(after! (:and org org-roam)
  (map!
    "s-SPC SPC" 'org-roam-node-find
    "s-SPC n" 'org-roam-dailies-capture-today
    :map org-mode-map
    "s-SPC i"  nil
    "s-SPC i i"  'org-roam-node-insert
    "s-t"  'org-roam-tag-add))
;; org-roam:1 ends here

;; [[file:config.org::*Retangle][Retangle:1]]
(remove-hook 'org-mode-hook #'+literate-enable-recompile-h)
;; Retangle:1 ends here

;; [[file:config.org::*reduce-map!][reduce-map!:1]]
(defmacro reduce-map! (initial &rest func-symbols)
  (let (($i (eval initial)))
    `(seq-reduce (lambda (red map-func) (mapcar map-func red))
      (quote ,func-symbols)
      (quote ,$i))))
;; reduce-map!:1 ends here

;; [[file:config.org::*EVIL!][EVIL!:1]]
(after! (evil doom)
  (evil-set-initial-state 'fundamental-mode 'emacs))
(map! :after evil
      :map global-map
      "s-SPC :" 'evil-ex)
;; EVIL!:1 ends here

;; [[file:config.org::*Catppuccin][Catppuccin:1]]
(after! catppuccin-theme
  (setq doom-theme 'catppuccin
        catpuccin-flavor 'mocha))
;; Catppuccin:1 ends here

;; [[file:config.org::*multiple-cursors][multiple-cursors:1]]
(use-package! multiple-cursors
  :bind (:map global-map
              ("s-SPC a" . 'mc/edit-beginnings-of-lines)
              ("s-SPC e" . 'mc/edit-ends-of-lines)))
;; multiple-cursors:1 ends here

;; [[file:config.org::*expand-region][expand-region:1]]
(after! expand-region
  (map!
    "s-SPC m f" 'er/mark-defun
    "s-SPC m f" 'er/mark-defun
    "C-="       'er/expand-region))
;; expand-region:1 ends here

;; [[file:config.org::*mode][org-mode:1]]
(setq-hook! '(org-mode-hook)
  display-line-numbers nil)
;; org-mode:1 ends here

;; [[file:config.org::*org-agenda][[0/3] org-agenda:1]]
(setq-hook! '(org-mode-hook)
    org-agenda-files "~/.agenda"
    org-agenda-force-single-file nil)

(use-package! org-agenda
  :custom
  (org-agenda-sticky t))
;; [0/3] org-agenda:1 ends here

;; [[file:config.org::*org-roam][[0/1] org-roam:1]]
(after! (:and org-roam expand-region)
  (defun advice/before--org-roam-node-insert (&rest rest)
    (when-let (($ (symbol-at-point)))
      (er/mark-symbol)))
  (advice-remove 'org-roam-node-insert #'advice/before--org-roam-node-insert)
  (advice-add 'org-roam-node-insert :before #'advice/before--org-roam-node-insert))

(use-package! org-roam
  :after org
  :commands (org-roam-node-insert
             org-roam-dailies-capture-today
             org-roam-node-find)
  :bind (("s-SPC SPC" . org-roam-node-find)
         ("s-SPC n" . org-roam-dailies-capture-today)
         :map org-mode-map
         ("s-SPC i" . nil)
         ("s-SPC i i" . org-roam-node-insert)
         ("s-t" . org-roam-tag-add)))
;; [0/1] org-roam:1 ends here

;; [[file:config.org::*Ansible][Ansible:4]]
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               `(yaml-mode . ,(eglot-alternatives
                              '(("ansible-language-server" "--stdio"))))))
;; Ansible:4 ends here

;; [[file:config.org::*Ansible][Ansible:5]]
(map! :mode ansible-mode
      :map yaml-mode-map
      "s-h" #'ansible-doc)
;; Ansible:5 ends here

;; [[file:config.org::*Ansible][Ansible:7]]
(setq-hook! '(+ansible-yaml-mode ansible-mode-hook)
  select-enable-clipboard t
  make-backup-files nil
  auto-save-default nil)
;; Ansible:7 ends here

;; [[file:config.org::*projectile][projectile:1]]
(use-package! projectile
;; projectile:1 ends here

;; [[file:config.org::*projectile][projectile:3]]
:hook ((projectile-after-switch-project . (treemacs-display-current-project-exclusively)))
;; projectile:3 ends here

;; [[file:config.org::*projectile][projectile:6]]
:bind (("s-p" . nil)
       ("s-r" . 'projectile-recentf)
       ("s-p p" . 'projectile-switch-project)
       ("s-p s-p" . 'projectile-find-file))
;; projectile:6 ends here

;; [[file:config.org::*projectile][projectile:7]]
)
;; projectile:7 ends here

;; [[file:config.org::*corfu-mode][corfu-mode:1]]
(after! corfu
  (setq corfu-auto-delay 1.0))
;; corfu-mode:1 ends here

;; [[file:config.org::bindings][bindings]]
(map!
 :map global-map
 ;; "s-/"            '+default/search-buffer

 "s-/"            'consult-imenu

 "s-SPC x"        'doom/open-scratch-buffer

 "s-r"            'consult-buffer

 "s-g"            'magit


 "s-<backspace>"  'delete-pair

 "M-\["           'previous-error
 "M-\]"           'next-error

 "s-\["           'undo
 "s-\]"           'undo-redo

 "M-s-\["         'winner-undo
 "M-s-\]"         'winner-redo

 "s-k"            'delete-window
 "M-s-k"          'doom/kill-this-buffer-in-all-windows
 "s-n"            (cmd! (when (split-window-sensibly))) :desc "split-window-sensibly"
 "M-s-n"          (cmd! (when (split-window)))          :desc "split-window"

 "M-s-e"          'windmove-swap-states-right
 "M-s-q"          'windmove-swap-states-left
 "M-s-w"          'windmove-swap-states-up
 "M-s-s"          'windmove-swap-states-down

 "C-."            'mc/mark-next-like-this-word
 "C->"            'mc/unmark-next-like-this

 "s-e"            'windmove-right
 "s-q"            'windmove-left
 "s-w"            'windmove-up
 "s-s"            'windmove-down

 "s-."            'mc/mark-all-like-this
 "s->"            'mc/unmark-all-like-this

 "s-SPC s-SPC"    'execute-extended-command

 "s-SPC q"        'delete-other-windows
 "s-SPC ."        'consult-mark
 "s-SPC <return>" nil

 (:prefix "s-SPC <return>"

          "SPC"   'balance-windows
          "<return>" 'consult-bookmark
          )
 )
;; bindings ends here

;; [[file:config.org::*=s-SPC l=][=s-SPC l=:1]]
(map! :map global-map
      :prefix "s-SPC l"
      "l" 'consult-locate
      "e" 'consult-flycheck
      "P" '+pass/consult
      "h" '+default/man-or-woman)
;; =s-SPC l=:1 ends here
