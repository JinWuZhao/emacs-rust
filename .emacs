;;; -*- lexical-binding:t -*-

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (xclip color-theme smex protobuf-mode real-auto-save company-restclient restclient zoom-window neotree f zoom highlight-parentheses flycheck markdown-mode company-lsp counsel yasnippet-snippets rust-mode lsp-rust ace-window magit)))
 '(zoom-size (quote (0.618 . 0.618))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun require-package (package &optional min-version no-refresh)
  "Install given PACKAGE, optionally requiring MIN-VERSION.
If NO-REFRESH is non-nil, the available package lists will not be
re-downloaded in order to locate PACKAGE."
  (if (package-installed-p package min-version)
      t
    (if (or (assoc package package-archive-contents) no-refresh)
        (if (boundp 'package-selected-packages)
            ;; Record this as a package the user installed explicitly
            (package-install package nil)
          (package-install package))
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))

(defun require-packages (packages)
  (while packages
    (require-package (car packages))
    (setq packages (cdr packages)))
  t)

(require-packages package-selected-packages)

;; (add-to-list 'load-path (expand-file-name (locate-user-emacs-file "custom")))

(display-time)
(setq explicit-shell-file-name "/bin/bash")

(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)
(electric-pair-mode t)

(require 'highlight-parentheses)
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)

(require 'real-auto-save)
(setq real-auto-save-interval 1)
(add-hook 'prog-mode-hook 'real-auto-save-mode)

(global-set-key (kbd "C-c .") 'highlight-symbol-at-point)
(global-set-key (kbd "C-c ,") 'unhighlight-regexp)

(global-set-key (kbd "C-c /") 'comment-region)
(global-set-key (kbd "C-c k") 'uncomment-region)
(global-set-key (kbd "C-c l") 'comment-line)

(global-set-key (kbd "C-c g") 'magit-status)

(require 'zoom)
(global-set-key (kbd "M-+") 'zoom)
(global-set-key (kbd "M-_") 'balance-windows)

(require 'zoom-window)
(global-set-key (kbd "C-x +") 'zoom-window-zoom)
(global-set-key (kbd "C-x _") 'zoom-window-next)

(global-set-key (kbd "M-o") 'ace-window)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
(setq aw-dispatch-always nil)

(require 'company-lsp)
(push 'company-lsp company-backends)

(require 'yasnippet)
(yas-global-mode 1)

(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key (kbd "C-c C-s") 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-c m") 'counsel-bookmark)
(global-set-key (kbd "C-c r") 'counsel-rg)
(global-set-key (kbd "C-c i") 'counsel-imenu)
(global-set-key (kbd "C-c b") 'counsel-ibuffer)
(global-set-key (kbd "C-c j") 'counsel-file-jump)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

(require 'zone)
(zone-when-idle 300)

(setq confirm-kill-emacs 'yes-or-no-p)

(require 'bookmark)
(setq bookmark-default-file "/mnt/share/Documents/.bookmark")

(push 'company-restclient company-backends)
(add-hook 'restclient-mode-hook #'company-mode-on)

(with-eval-after-load 'lsp-mode
  (setq lsp-rust-rls-command '("rustup" "run" "rls"))
  (require 'lsp-rust))

(add-hook 'rust-mode-hook #'lsp-rust-enable)
