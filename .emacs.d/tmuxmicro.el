;;; tmuxmicro.el --- Keybinds ported from a tmux/micro setup. -*- coding: utf-8; -*-

(require 'term)
(global-undo-tree-mode 1)
(cua-mode t)
(setq cua-keep-region-after-copy t)
(setq org-support-shift-select t)
(setq recording-macro nil)
(setq-default truncate-lines t)
;(setq shift-select-mode t)

;; Some functions for the keybinds
(defun delete-window-or-kill-emacs ()
  (interactive)
  (condition-case nil
    (delete-window)
  (error
    (kill-emacs)
  )))

(defun toggle-macro ()
  (interactive)
  (if recording-macro
    (progn
      (call-interactively 'kmacro-end-macro)
      (setq recording-macro nil)
      (message "Done!"))
    (progn
      (call-interactively 'kmacro-start-macro)
      (setq recording-macro t)
      (message "Recording macro..."))))

(defun play-macro ()
  (interactive)
  (call-interactively 'kmacro-end-and-call-macro)
  (message "Played macro!"))

(defun cut-current-line ()
  (interactive)
  (call-interactively 'move-beginning-of-line)
  (call-interactively 'set-mark-command)
  (call-interactively 'forward-line)
  (call-interactively 'kill-region)
  (message "Snip!"))

(defun rotate-windows ()
  (interactive)
  (dotimes (n (- (count-windows) 1))
    (call-interactively 'window-swap-states)
    (call-interactively 'other-window))
  (message "Bananas r o t a t e"))

(defun duplicate-line ()
  (interactive)
  (call-interactively 'move-beginning-of-line)
  (call-interactively 'set-mark-command)
  (call-interactively 'forward-line)
  (call-interactively 'kill-ring-save)
  (call-interactively 'yank)
  (call-interactively 'previous-line)
  (call-interactively 'move-end-of-line)
  (message "Duplicated line!"))

(defun window-conf-hook ()
  (let ((display-table (or buffer-display-table standard-display-table)))
    (set-display-table-slot display-table 5 ?|)
    (set-window-display-table (selected-window) display-table)))

(defun expose-global-bind (mapping key)
  (define-key mapping key
    (lookup-key (current-global-map) key)))

(defun terminal ()
  (interactive)
  (message "Termboi!")
  (term (getenv "SHELL")))

(defun previous-window ()
  (interactive)
  (let ((win (get-mru-window t t t)))
    (unless win (error "there's no previous window"))
    (let ((frame (window-frame win)))
      (select-frame-set-input-focus frame)
      (select-window win))))
  (message "Selected previous window!")

;; Keybinds
(global-unset-key (kbd "C-s"))
(global-unset-key (kbd "C-o"))
(global-unset-key (kbd "C-y"))
(global-unset-key (kbd "C-z"))
(global-set-key (kbd "C-s") 'save-buffer)                 ; [C-s]    save
(global-set-key (kbd "C-o") 'find-file)                   ; [C-o]    open
(global-set-key (kbd "C-z") 'undo-tree-undo)              ; [C-z]    undo
(global-set-key (kbd "C-y") 'undo-tree-redo)              ; [C-y]    redo
(global-set-key (kbd "C-q") 'delete-window-or-kill-emacs) ; [C-q]    close current window
(global-set-key (kbd "C-u") 'toggle-macro)                ; [C-u]    toggle macro
(global-set-key (kbd "C-j") 'play-macro)                  ; [C-j]    play macro
(global-set-key (kbd "C-d") 'duplicate-line)              ; [C-d]    duplicate line
(global-set-key (kbd "<home>") 'move-beginning-of-line)   ; [<home>] go to beginning the line
(global-set-key (kbd "<select>") 'move-end-of-line)       ; [<end>]  go to end of line
(global-set-key (kbd "C-f") 'isearch-forward)             ; [C-f]    find
(global-set-key (kbd "C-h") 'query-replace)               ; [C-h]    find & replace
(global-set-key (kbd "C-k") 'cut-current-line)            ; [C-k]    cut line
(global-set-key (kbd "C-a") 'mark-whole-buffer)           ; [C-a]    select all
(global-set-key (kbd "C-g") 'goto-line)                   ; [C-g]    goto line
(global-set-key (kbd "M-h") 'help-command)                ; [M-h]    help
(global-set-key (kbd "M-t") 'terminal)                    ; [M-t]    terminal         \
(global-set-key (kbd "M-r") 'recover-this-file)           ; [M-r]    recover file     |
(global-set-key (kbd "M-e") 'eval-buffer)                 ; [M-e]    eval buffer      | NOT MICRO
(global-set-key (kbd "M-i") 'package-install)             ; [M-i]    install package  |
(global-set-key (kbd "M-l") 'ielm)                        ; [M-l]    lisp interpreter /
(define-prefix-command 'tmux)                             ;
(global-set-key (kbd "C-b") 'tmux)                        ;
(define-key tmux (kbd "C-o") 'rotate-windows)             ; [C-b C-o]  rotate panes
(define-key tmux (kbd "o") 'other-window)                 ; [C-b o]    rotate selection
(define-key tmux (kbd ";") 'previous-window)              ; [C-b ;]    select previous pane
(define-key tmux (kbd "\"") 'split-window-below)          ; [C-b "]    split window vert
(define-key tmux (kbd "%") 'split-window-right)           ; [C-b %]    split window horz
(define-key tmux (kbd "[") 'previous-buffer)              ; [C-b []    previous buffer   \ NOT
(define-key tmux (kbd "]") 'next-buffer)                  ; [C-b ]]    next buffer       / TMUX

(set-face-background 'vertical-border "white")            ; \ Make window borders look
(set-face-foreground 'vertical-border "black")            ; /     more like tmux

;; Apply hooks
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'window-configuration-change-hook 'window-conf-hook)

;; Misc.
(setq-default mode-line-format "%b %& (%c,%l) | ft:%m | unix | utf-8") ; Make mode-line look like micro's status bar
(menu-bar-mode -1)                                                     ; Get rid of the menu bar
(expose-global-bind term-raw-map (kbd "C-b"))
(expose-global-bind term-raw-map (kbd "C-q"))
