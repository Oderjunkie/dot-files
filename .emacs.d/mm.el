;;; mm.el --- Syntax highlighting for the tinymm8 language. -*- coding: utf-8; lexical-binding: t; -*-

(setq tinymm8-font-lock
      (let* (
	  (x-kws   '("if" "noninline" "return"))
          (x-kws-re (regexp-opt x-kws 'words)))
      `(
         ;("\".*\""                                                     . font-lock-string-face)
          ("[ui]\\(8\\|16\\|32\\|64\\)"                                 . font-lock-type-face)
          ("0x[0-9a-fA-F]*"                                             . font-lock-constant-face)
          ("[1-9][0-9]*"                                                . font-lock-constant-face)
          ("0[0-7]*"                                                    . font-lock-constant-face)
          ("\\(?<=[ui]\\(8\\|16\\|32\\|64\\)\\) [a-zA-Z_][a-zA-Z0-9_]*" . font-lock-variable-name-face)
          ("[a-zA-Z_][a-zA-Z0-9_]*(?=\\("                               . font-lock-function-name-face)
          (,x-kws-re                                                    . font-lock-keyword-face)
          ("\\(?<=\\/\\/\\).*"                                          . font-lock-comment-face)
          ("\\/\\/"                                                     . font-lock-comment-deliminator-face)
	  )))

(define-derived-mode tinymm8-mode fundamental-mode "tinymm8"
  "Major mode for scripting in the Tiny Macho Machine 8bit language."
  (set (make-local-variable 'font-lock-defaults) '((tinymm8-font-lock))))

(provide 'tinymm8-mode)

(add-to-list 'auto-mode-alist '("\\.mm\\'". tinymm8-mode))
