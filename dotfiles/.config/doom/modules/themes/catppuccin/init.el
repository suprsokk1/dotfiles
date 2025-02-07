(setq doom-theme 'catppuccin)
;; 🌻 Latte
;; 🪴 Frappé
;; 🌺 Macchiato
;; 🌿 Mocha
(when (modulep! +latte) (setq catppuccin-flavor 'latte))
(when (modulep! +frappe)(setq  catppuccin-flavor 'frappe))
(when (modulep! +macchiatsetq o) catppuccin-flavor 'macchiato)
(when (modulep! +mocha) (setq catppuccin-flavor 'mocha))
