;; Set environment to Chinese-Big5
(set-language-environment 'chinese-big5)
(set-keyboard-coding-system 'chinese-big5)
(set-terminal-coding-system 'chinese-big5)
(set-buffer-file-coding-system 'chinese-big5)
(set-selection-coding-system 'chinese-big5)
(modify-coding-system-alist 'process "*" 'chinese-big5)
;; Do not conflicts with xcin hook
(global-set-key (kbd "M-SPC") 'set-mark-command)
;; ---------------------------------------------------------------------------
;; to get emacs a bit more consistent, replace all yes or no questions with
;; simple y or n. 
;; ---------------------------------------------------------------------------
;;(fset 'yes-or-no-p 'y-or-n-p)
;; --Use Windoze style selection
;;(custom-set-variables
;; '(pc-selection-mode t nil (pc-select)))
;; To make sure you get as much highlighting as possible
;; (global-font-lock-mode t)
;; (setq-default font-lock-maximum-decoration t)
;; Don't ask me more about emacs customization ! You should read the
;; manual or just ask google.com.
