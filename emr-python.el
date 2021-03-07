;;; emr-python.el --- Refactoring commands for Python  -*- lexical-binding: t; -*-

;; Copyright (C) 2016 Chris Barrett

;; Author: Chris Barrett <chris.d.barrett@me.com>

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Refactoring commands for Python mode.

;;; Code:

(require 'emr)

; ------------------

;;; EMR Declarations
(autoload 'py-autopep8-buffer "py-autopep8"
  "Uses the \"autopep8\" tool to reformat the current buffer."  t)

(defun emr-pythonc-format-buffer ()
  "Format region (START/END) with clang-format."
  (interactive)
  (py-autopep8-buffer))

(defun emr-pythonpp-try-catch (start end)
  "Surround region between START & END with try-catch."
      (interactive "rp")
    (let ((content (buffer-substring-no-properties start end)))
      (save-excursion
        (delete-region start end)
        (insert "try {\n")
        (insert content)
        (insert
         "}\ncatch (exception& e) {\n")
        (insert "throw ;\n}\n")
        ;; (emr-pythonc-format-region start (point))
        )))

; ------------------

;;; EMR Declarations

(emr-declare-command 'emr-pythonc-format-buffer
  :title "format buffer"
  :description "with autopep8"
  :modes '(python-mode)
  :predicate (lambda ()
               (and
                (not (and
                      (bound-and-true-p lsp-mode)
                      (or (lsp--capability "documentFormattingProvider")
                          (lsp--registered-capability "textDocument/formatting"))
                      (not mark-active)))
                (not mark-active)
                (executable-find "autopep8"))))

(emr-declare-command 'emr-pythonpp-try-catch
  :title "surround"
  :description "with try-catch"
  :modes '(python-mode)
  :predicate (lambda ()
               (and mark-active (not (equal (mark) (point))))))

(provide 'emr-python)

;;; emr-python.el ends here
