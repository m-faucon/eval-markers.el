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

(defvar eval-markers-want-classical-last-sexp-behaviour nil)

(defvar eval-markers-pp nil)

(defun eval-markers-new (char)
  (interactive "c")
  (unless (get major-mode 'eval-markers-eval-fn)
    (user-error "No eval-fn for this major mode"))
  (setf (alist-get char eval-markers-markers)
        (if eval-markers-want-classical-last-sexp-behaviour
            (save-excursion
              (backward-sexp)
              (point-marker))
            (point-marker))))

(defun eval-markers-toggle-pp (char)
  (interactive "c")
  (let ((pp-p (alist-get char eval-markers-pp)))
    (setf (alist-get char eval-markers-pp) (not pp-p))))

(defun eval-markers-eval (char arg)
  (interactive "c\nP")
  (when arg
    (eval-markers-toggle-pp char))
  (let ((m (alist-get char eval-markers-markers)))
    (unless m
      (user-error "No form registered at char %c" char))
    (with-current-buffer (marker-buffer m)
      (save-excursion
        (goto-char (marker-position m))
        (if-let ((eval-fn (or (and (alist-get char eval-markers-pp)
                                   (get major-mode 'eval-markers-eval-pp-fn))
                              (get major-mode 'eval-markers-eval-fn))))
            (funcall eval-fn)
          (user-error "No eval-fn for this major mode"))))))

(with-eval-after-load 'cider
  (put 'clojure-mode 'eval-markers-eval-fn (lambda () (forward-sexp) (cider-eval-last-sexp)))
  (put 'clojure-mode 'eval-markers-eval-pp-fn (lambda () (forward-sexp) (cider-pprint-eval-last-sexp))))

(put 'emacs-lisp-mode 'eval-markers-eval-fn (lambda () (forward-sexp) (eros-eval-last-sexp nil)))

(provide 'eval-markers)
;;; eval-markers.el ends here
