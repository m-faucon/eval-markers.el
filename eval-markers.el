;;; eval-markers.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2023 Marc Faucon
;;
;; Created: septembre 26, 2023
;; Modified: septembre 26, 2023
;; Version: 0.0.1
;; Homepage: https://github.com/m-faucon/eval-markers.el
;; Package-Requires: ((emacs "25.1"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(defvar eval-markers-markers nil)

(defun eval-markers-new (char)
  (interactive "c")
  (unless (get major-mode 'eval-markers-eval-fn)
    (error "No eval-fn for this major mode"))
  (setf (alist-get char eval-markers-markers) (point-marker)))

(defun eval-markers-eval (char)
  (interactive "c")
  (let ((m (alist-get char eval-markers-markers)))
    (with-current-buffer (marker-buffer m)
      (save-excursion
        (goto-char (marker-position m))
        (if-let ((eval-fn (get major-mode 'eval-markers-eval-fn)))
            (funcall eval-fn)
          (error "No eval-fn for this major mode"))))))

(when (featurep 'cider)
  (put 'clojure-mode 'eval-markers-eval-fn (lambda () (forward-sexp) (cider-eval-last-sexp))))

(put 'emacs-lisp-mode 'eval-markers-eval-fn (lambda () (forward-sexp) (eros-eval-last-sexp nil)))


(provide 'eval-markers)

;;; eval-markers.el ends here
