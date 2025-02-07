;; ;; Configure packages
;; ;; First - if not using nix, then initialize melpa.
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)
;;
;; Install use-package.
;; (eval-when-compile (require 'use-package))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
;; 
;; (unless (package-installed-p 'auto-package-update)
;;   (package-install 'auto-package-update))
;; 
;; ;; Enable Auto Package Update
;; ;; Also consider using https://github.com/jwiegley/use-package
;; (require 'auto-package-update)
;; (setq auto-package-update-delete-old-versions t)
;; (setq auto-package-update-hide-results t)
;; 
;; (unless (package-installed-p 'org)
;;   (package-install 'org))
;; 
;; (unless (package-installed-p 'org-ac)
;;   (package-install 'org-ac))
;; 
;; (unless (package-installed-p 'org-download)
;;   (package-install 'org-download))
;; 
;; (unless (package-installed-p 'org-journal)
;;   (package-install 'org-journal))
;; 
;; (auto-package-update-maybe)
;; 
;; ;; END: Configure Packages

(use-package darcula-theme
    :ensure t)

(use-package org
    :ensure t)

(use-package org-ac
    :ensure t)

(use-package org-download
    :ensure t)

(use-package org-journal
    :ensure t)

(use-package org-roam
    :ensure t)

(use-package markdown-mode
    :ensure t)

(use-package nix-mode
    :ensure t)

(use-package python-mode
    :ensure t)

(setq cfg-dotfiles (getenv "DOTFILES"))
(load "~/.emacs.d/misc-cmds.el") 

;; Get Customize stuff out of init.el
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file t)

;; Open file-links in the same window
;; https://stackoverflow.com/questions/17590784/how-to-let-org-mode-open-a-link-like-file-file-org-in-current-window-inste
;; (let (org-link-frame-setup) (file . find-file))

;; Prefer to split windows vertically.
(setq split-width-threshold 10)

;; Visual word wrap
;; https://stackoverflow.com/questions/3281581/how-to-word-wrap-in-emacs
(global-visual-line-mode t)
;; (add-hook 'org-mode-hook #'toggle-word-wrap)  ;; https://www.reddit.com/r/emacs/comments/43vfl1/enable_wordwrap_in_orgmode/

;; https://www.emacswiki.org/emacs/MoveLine
(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))


;; https://www.emacswiki.org/emacs/CopyingWholeLines#toc7
(defun quick-copy-line ()
  "Copy the whole line that point is on and move to the beginning of the next line.
Consecutive calls to this command append each line to the
kill-ring."
  (interactive)
  (let ((beg (line-beginning-position 1))
        (end (line-beginning-position 2)))
    (if (eq last-command 'quick-copy-line)
        (kill-append (buffer-substring beg end) (< end beg))
      (kill-new (buffer-substring beg end))))
  (beginning-of-line 2))

;; [[https://emacs.stackexchange.com/questions/32958/insert-line-above-below][Inserting lines]]
(defun insert-line-below ()
  (interactive)
  (move-end-of-line nil)
  (open-line 1))

(defun insert-line-above ()
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (indent-according-to-mode))

;; Refresh all buffers when changed on disk.
;; https://stackoverflow.com/questions/1480572/how-to-have-emacs-auto-refresh-all-buffers-when-files-have-changed-on-disk
(global-auto-revert-mode t)

;; Set up custom keys
(windmove-default-keybindings)
(global-set-key [C-S-prior] 'windmove-up)
(global-set-key [C-S-next] 'windmove-down)
(global-set-key [C-prior] 'windmove-left)
;; (define-key org-mode-map [M-{] nil)
(global-set-key [M-{] 'windmove-left)
(global-set-key [C-next] 'windmove-right)
;; (define-key org-mode-map [M-}] nil)
(global-set-key [M-}] 'windmove-right)
(global-set-key [f5] 'revert-buffer-no-confirm)
(global-set-key [M-up] 'move-line-up)
(global-set-key [M-down] 'move-line-down)
(global-set-key (kbd "C-v") 'clipboard-yank)
(global-set-key (kbd "C-M-y") 'quick-copy-line)
(global-set-key (kbd "C-o") 'insert-line-below)
(global-set-key (kbd "C-S-o") 'insert-line-above)
(define-key key-translation-map (kbd "ESC") (kbd "C-g"))
;; (global-set-key (kbd "i") 'string-insert-rectangle)
;; https://emacs.stackexchange.com/questions/19598/org-mode-link-to-heading-in-other-org-file
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c C-l") 'org-insert-link)

;; Orgmode stuff
;; (defun jjw-org-sync ()
;;   "Does auto-push of repo."
;;   (interactive)
;;   (save-some-buffers "!")
;;   (shell-command (concat org-directory "/sync.sh")))

;; (global-set-key [f8] 'jjw-org-sync)
;; (global-set-key [XF86AudioPrev] 'jjw-org-sync)

(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-c\C-w" 'org-refile)

;; https://emacs.stackexchange.com/questions/26363/downscaling-inline-images-in-org-mode
(setq org-image-actual-width nil)

(setq org-return-follows-link t)
(setq org-hide-leading-stars t)

(setq org-todo-keywords
      '((sequence "TODO" "DOING" "WAITING" "|" "DONE" "CANCELED")))

;; These let you quickly tag headings with `C-c C-c`.
(setq org-tag-alist (quote ((:startgroup)
                             ("@chore" . ?h)
                             ("@code" . ?c)
                             ("@errand" . ?e)
                             ("@leisure" . ?l)
                             ("@reading" . ?r)
                             ("@web" . ?b)
                             ("@writing" . ?w)
                             (:endgroup)
                             ("milestone" . ?m)
                             ("project" . ?p)
                             ("fun" . ?f))))

(setq org-log-done 'time)
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-directory "~/notes")

;; Disabled to avoid inbox cluttering refiling. (setq org-agenda-files (file-expand-wildcards (concat org-directory "/*.org")))
;; (setq org-agenda-files (file-expand-wildcards (concat org-directory "/gtd/*.org")))
;; (setq org-agenda-files (file-expand-wildcards (concat org-directory "/*.org")))
(setq org-agenda-file-regexp "\\`[^.#].*\\.org\\'")
(setq org-agenda-files (
			append
			(file-expand-wildcards (concat org-directory "/*.org"))))
			;; (file-expand-wildcards (concat org-directory "/*/*.org"))))
(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
;;			   (org-other-files :maxlevel . 3)))

;; org-journal, https://github.com/bastibe/org-journal
(setq org-journal-dir (concat org-directory "/journal/"))
(setq org-journal-date-format "%Y/%m/%d (%A)")
(setq org-journal-file-type 'weekly)
(setq org-journal-start-on-weekday '0)
(setq org-journal-file-format "%Y-%m-%d.org")
(setq org-journal-file-header "Notes for week of %Y/%m/%d")

;; import packages
(require 'org)
(require 'org-ac)
(require 'org-download)
(require 'org-journal)
;; (require 'org-tempo)

;; mode-specific keys
(define-key org-mode-map "\C-c\C-j" 'org-journal-new-entry)

(add-to-list 'org-structure-template-alist
             '("s" . "src"))

;; Org Roam
(setq org-roam-directory "~/notes/org-roam")

