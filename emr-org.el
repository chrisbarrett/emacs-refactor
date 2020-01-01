;;; emr-org.el -- Brief introduction here.

;; Author: YangYingchao <yangyingchao@gmail.com>

;;; Commentary:

;;; Code:

(require 'emr)

(defun emr-org-quote (start end)
  "Format region (START/END) using clang."
  (interactive "rp")
  (save-excursion
    (let* ((content (buffer-substring-no-properties start end))
           (env (completing-read "Quote with: " '("SRC" "QUOTE")
                                 nil nil nil nil "QUOTE"))
           (opts (if (string= env "SRC")
                     (completing-read "Options: " nil nil nil nil "text"))))
      (kill-region start end)
      (insert (format "#+BEGIN_%s\n%s\n#+END_%s\n"
                      (if opts
                          (format "%s %s" env opts) env)
                      content env)))))

(emr-declare-command 'emr-org-quote
  :title "quote"
  :description "with special env"
  :modes '(org-mode)
  :predicate (lambda ()
               (and mark-active (not (equal (mark) (point))))))

(provide 'emr-org)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:

;;; emr-org.el ends here
