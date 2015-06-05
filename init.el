;; packages installer - borrowed from github.com/bodil/ohai-emacs
(setq dotfiles-dir (file-name-directory
                    (or (buffer-file-name) (file-chase-links load-file-name))))

;; check for internet connexion
(require 'cl)
(defun internet-online? ()
  "Check for internet connexion"
  (if (and (functionp 'network-interface-list)
           (network-interface-list))
      (some (lambda (iface) (unless (equal "lo" (car iface))
                         (member 'up (first (last (network-interface-info
                                                   (car iface)))))))
            (network-interface-list))
    t))

;; setup packages repos
;; gnu          : http://elpa.gnu.org/packages/
;; melpa        : http://melpa.org/packages/
;; melpa-stable : http://stable.melpa.org/packages/
;; milkbox      : http://melpa.milkbox.net/packages/
;; marmalade    : http://marmalade-repo.org/packages/
;; sunrise      : http://joseito.republika.pl/sunrise-commander/
;; orgmode      : http://orgmode.org/elpa/
(setq package-user-dir (concat dotfiles-dir "elpa"))
(require 'package)
(dolist (source '(("gnu"       . "http://elpa.gnu.org/packages/")
                  ("melpa"     . "http://melpa.org/packages/")))
  (add-to-list 'package-archives source t))

(package-initialize)

;; install packages if not already available
(when (internet-online?)
  (unless package-archive-contents (package-refresh-contents)))

(defun package-require (pkg)
  "Install a given package from the online repos"
  (when (not (package-installed-p pkg))
    (package-install pkg)))

(package-require 'smex)
(package-require 'ac-php)
(package-require 'ac-etags)
(package-require 'popup) 
(package-require 'ace-jump-mode)
(package-require 'auto-compile)
(package-require 'linum-off)
(package-require 'auto-complete)
(package-require 'auto-complete-c-headers)
(package-require 'auto-complete-clang)
(package-require 'color-theme-buffer-local)
(package-require 'dash)
(package-require 'deferred)
(package-require 'expand-region)
(package-require 'flymake-css)
(package-require 'flymake-easy)
(package-require 'flymake-jshint)
(package-require 'flymake-json)
(package-require 'flymake-php)
(package-require 'flymake-python-pyflakes)
(package-require 'flycheck-pos-tip)
(package-require 'flx-ido)
(package-require 'helm)
(package-require 'log4e)
(package-require 'magit) 
(package-require 'neotree) 
(package-require 'markdown-mode) 
(package-require 'php-mode)
(package-require 'csharp-mode)
(package-require 'projectile)
(package-require 'rich-minority)
(package-require 'undo-tree)
(package-require 'sage-shell-mode)
(package-require 'tracking)
(package-require 'web-mode)
(package-require 'yasnippet)

;; powerline - this one's better https://github.com/jonathanchu/emacs-powerline
(add-to-list 'load-path "~/.emacs.d/vendor/emacs-powerline")

(package-initialize)

;; theme
(custom-set-variables
 '(display-time-mode t)
 '(tool-bar-mode nil)
 '(custom-enabled-themes (quote (wombat)))
 '(initial-frame-alist (quote ((fullscreen . fullboth)))))
(custom-set-faces
 '(scroll-bar ((t (:foreground "black")))))

;; transparent
(set-frame-parameter (selected-frame) 'alpha '(95 85))
(add-to-list 'default-frame-alist '(alpha 95 85))

;; you no say
(setq
  inhibit-startup-message t
  make-backup-files nil
  create-lockfiles nil
  initial-scratch-message ""
  revert-without-query '(".*"))
(fset 'yes-or-no-p 'y-or-n-p)
(defun display-startup-echo-area-message ()
  "Erase the echo area at start up"
  (message ""))

;; line numbers
(global-linum-mode t)
(setf column-number-mode t)
(setf size-indication-mode t)
(global-linum-mode 1)
(setq linum-format " %d ")

;; Disable scroll bar
(scroll-bar-mode 0)

;; Better Scrolling
(setq scroll-margin 2)
(setq mouse-wheel-scroll-amount '(4 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq scroll-conservatively 100000)
(setq scroll-preserve-screen-position t)

;; highlight current line
(global-hl-line-mode  1)
(set-face-background  'highlight "#222")
(set-face-foreground  'highlight nil)
(set-face-underline-p 'highlight nil)

;; cursor types : hbar bar box
(set-default 'cursor-type 'bar)

;; Undo/redo window configuration with C-c <left>/<right>
(winner-mode 1)

;; who thought this was a good idea
(setq ring-bell-function 'ignore)

(windmove-default-keybindings 'meta)

;; where you been all my life
(require 'undo-tree)

;; auto refresh-file when modified external
(global-auto-revert-mode t)

(desktop-save-mode 1)

(require 'powerline)
(set-face-attribute 'mode-line nil
                    :foreground "Black"
                    :background "#fcad00"
                    :box nil)

;; Smex is a M-x enhancement for Emacs. 
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;;; helm
(require 'helm-config)
(helm-mode 1)
(helm-autoresize-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)

;; auto-complete
(require 'auto-complete-config)
(ac-config-default)
(setq ac-auto-show-menu 0.0)
(set-face-background 'ac-candidate-face "lightgray")
(set-face-underline  'ac-candidate-face "darkgray")
(set-face-background 'ac-selection-face "steelblue")

;; neotree
(require 'neotree)

;; projectile
(projectile-global-mode)

;; magit
(require 'magit)
(setq magit-auto-revert-mode nil)
(setq magit-last-seen-setup-instructions "1.4.0")

;; ac-php
(require 'php-mode)
(add-hook 'php-mode-hook
        '(lambda ()
           (auto-complete-mode t)
           (require 'ac-php)
           (setq ac-sources  '(ac-source-php ))
           (yas-global-mode 1)
           (define-key php-mode-map  (kbd "C-]") 'ac-php-find-symbol-at-point) ; goto define
           (define-key php-mode-map  (kbd "C-t") 'ac-php-location-stack-back)  ; go back
           ))

;; csharp-mode
(require 'csharp-mode)

;; markdown
(require 'markdown-mode) 
(autoload 'markdown-mode "markdown-mode" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'"     . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'"       . markdown-mode))

;; flymake
(require 'flymake-php)
(add-hook 'php-mode-hook 'flymake-php-load)

(require 'flymake-jshint) ; requires jshint jshint.com/install/
(add-hook 'js-mode-hook 'flymake-mode)

(require 'flymake-css)
(add-hook 'css-mode-hook 'flymake-css-load)

(require 'flycheck-pos-tip)
(eval-after-load 'flycheck
  '(custom-set-variables
   '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages)))

;; key bindings
(global-set-key [f1] 'about-emacs) ;; ha
(global-set-key [f2] 'split-window-horizontally)
(global-set-key [f3] 'split-window-vertically)
(global-set-key [f4] 'delete-window)
(global-set-key [f5] 'refresh-file)
(global-set-key [f6] 'neotree-toggle)

(global-set-key (kbd "C-4") 'switch-to-buffer)
(global-set-key (kbd "C-5") 'switch-to-buffer-other-window)
(global-set-key (kbd "C-6") 'bs-show)

;; muscles memory
(global-set-key (kbd "C-z") 'undo-tree-undo)
(global-set-key (kbd "C-r") 'undo-tree-redo)
(global-set-key (kbd "C-v") 'yank)
(global-set-key (kbd "C-f") 'find-file)

(defun duplicate-line() ; http://stackoverflow.com/a/88828
  "Duplicate current line"
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
)
(global-set-key (kbd "C-d") 'duplicate-line)

(defun comment-or-uncomment-region-or-line () ; http://stackoverflow.com/a/9697222
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
      (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))
(global-set-key (kbd "C-q") 'comment-or-uncomment-region-or-line)

(defun un-indent-4-spaces () ; http://stackoverflow.com/a/2250155
  "Remove 4 spaces from beginning of of line"
  (interactive)
  (save-excursion
    (save-match-data
      (beginning-of-line)
      (when (looking-at "^\\s-+")
        (untabify (match-beginning 0) (match-end 0)))
      (when (looking-at "^    ")
        (replace-match "")))))

(global-set-key (kbd "<backtab>") 'un-indent-4-spaces)
