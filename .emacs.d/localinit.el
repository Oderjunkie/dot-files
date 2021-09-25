(defconst local-init (concat default-directory ".emacs-setup.el"))
(setq count 0)

;; Try to load .emacs-setup.el, if nonexistent, create the file.
(unless (file-exists-p local-init)
      (write-region "" "" local-init))

(add-hook 'window-buffer-change-functions (lambda (frame)
  (if (= count 0)
     (if (string= (buffer-name) "*GNU Emacs*")
        (load-file local-init)))
  (setq count (+ count 1))
))
