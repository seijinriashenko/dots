;;; My personal Emacs configuration -*- lexical-binding: t -*-

;; Save the contents of this file under ~/.emacs.d/init.el or ~/.config/emacs/init.el
;; Do not forget to use Emacs' built-in help system:
;; Use C-h C-h to get an overview of all help commands.  All you
;; need to know about Emacs (what commands exist, what functions do,
;; what variables specify), the help system can provide.

;;; Packages
(require 'package)
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(add-to-list 'package-archives '(("melpa" . "https://melpa.org/packages/")
				 ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(unless package-archive-contents (package-refresh-contents))

;; W/o this Emacs freezes when refreshing ELPA
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(package-initialize)
(setq package-enable-at-startup nil)

;; Initialize us-epackage on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
(setq use-package-verbose nil)

;;; Garbage collection
(use-package gcmh
  :diminish gcmh-mode
  :config
  (setq gcmh-idle-delay 5
	gcmh-high-cons-threshold (* 16 1024 1024)) ;; 16 mb
  (gcmh-mode 1))

(add-hook 'emacs-startup-hook
	  (lambda()
	    (setq gc-cons-percentage 0.1))) ;;Default value for `gc-cons-percentage'

(add-hook 'emacs-startup-hook
	  (lambda()
	    (message "Emacs ready in %s with %d garbage collections."
		     (format "%.2f seconds"
			     (float-time
			      (time-subtract after-init-time before-init-time)))
		     gcs-done)))


;;; EVIL: Vim Emulation
(use-package evil
  :init
  (setq evil-search-module 'evil-search)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-w-in-emacs-state t)
  (setq evil-want-Y-yank-to-eol t)
  (setq evil-want-fine-undo t)
  :config
  (evil-mode t))

;; Enable Vim emulation in programming buffers
;;(add-hook 'prog-mode-hook #'evil-local-mode)


;;; Theme
(load-theme 'modus-vivendi t)


;;; Fonts
(set-face-attribute 'default nil :font "monospace")


;;; Visuals

;;; Miscellaneous options
(setq-default major-mode
              (lambda () ; guess major mode from file name
                (unless buffer-file-name
                  (let ((buffer-file-name (buffer-name)))
                    (set-auto-mode)))))
(setq confirm-kill-emacs #'yes-or-no-p)
(setq window-resize-pixelwise t)
(setq frame-resize-pixelwise t)
(save-place-mode t)
(savehist-mode t)
(recentf-mode t)
(defalias 'yes-or-no #'y-or-n-p)

;; Store automatic customisation options elsewhere (assuming $XDG_CONFIG_HOME/emacs/custom.el)
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)  
  (load custom-file))


;;; Vertico: Completion framework
;; (use-package vertico
;;   :init
;;   (vertico-mode t) 
;;   (vertico-flat-mode t)
;;   :config
;;   (define-key vertico-map (kbd "RET") #'vertico-directory-enter)
;;   (define-key vertico-map (kbd "DEL") #'vertico-directory-delete-word)
;;   (define-key vertico-map (kbd "M-d") #'vertico-directory-delete-char)) 


;;; Consult: Extended completion utilities
;; (use-package consult
;;   :config
;;   (global-set-key [rebind switch-to-buffer] #'consult-buffer)
;;   (global-set-key (kbd "C-c j") #'consult-line)
;;   (global-set-key (kbd "C-c i") #'consult-imenu))
 

;;; Programming stuff
;; Enable line numbering in `prog-mode'
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; Automatically pair parentheses
(electric-pair-mode t)

;; Go Support
(use-package go-mode)
;; JSON Support
(use-package json-mode)
;; Lua Support
(use-package lua-mode)
;; Rust Support
(use-package rust-mode)
;; Additional Lisp support
(use-package sly)
;; Typescript Support
(use-package typescript-mode)
;; SWI-Prolog Support
(use-package sweeprolog)

;; Use `sweeprolog-mode' instead of `prolog-mode'
(add-to-list 'auto-mode-alist '("\.plt?\'"  . sweeprolog-mode))


;;; LaTeX support
;; (use-package auctex
;;   :config
;;   (setq TeX-auto-save t)
;;   (setq TeX-parse-self t)
;;   (setq-default TeX-master nil))
;;
;; ;; Enable LaTeX math support
;; (add-hook 'LaTeX-mode-map #'LaTeX-math-mode)
;;
;; ;; Enable reference mangment
;; (add-hook 'LaTeX-mode-map #'reftex-mode)


;;; Outline-based notes management and organizer
;; (global-set-key (kbd "C-c l") #'org-store-link)
;; (global-set-key (kbd "C-c a") #'org-agenda)


;;; Jump to arbitrary positions
;; (use-package avy
;;   :config
;;   (global-set-key (kbd "C-c z") #'avy-goto-word-1))


;;; Eglot: LSP Support
;; (use-package eglot)

;; Enable LSP support by default in programming buffers
;; (add-hook 'prog-mode-hook #'eglot-ensure)


;;; Flymake: Inline static analysis

;; Enable inline static analysis
;; (add-hook 'prog-mode-hook #'flymake-mode)

;; Display messages when idle, without prompting
;;(setq help-at-pt-display-when-idle t)

;; Message navigation bindings
;; (with-eval-after-load 'flymake
;;   (define-key flymake-mode-map (kbd "C-c n") #'flymake-goto-next-error)
;;   (define-key flymake-mode-map (kbd "C-c p") #'flymake-goto-prev-error))


;;; Corfu: Pop-up completion
;; (use-package corfu)

;; Enable autocompletion by default in programming buffers
;; (add-hook 'prog-mode-hook #'corfu-mode)

;;; Git client
;; (use-package magit
;;   :config
;;   ;; Bind the `magit-status' command to a convenient key.
;;   (global-set-key (kbd "C-c g") #'magit-status))


;;; Indication of local VCS changes
;; (use-package diff-hl
;;   :config
;;   ;; Update the highlighting without saving
;;   (diff-hl-flydiff-mode t))

;; Enable `diff-hl' support by default in programming buffers
;; (add-hook 'prog-mode-hook #'diff-hl-mode)
