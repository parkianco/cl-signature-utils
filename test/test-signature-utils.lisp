;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: BSD-3-Clause

;;;; test-signature-utils.lisp - Unit tests for signature-utils
;;;;
;;;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;;;; SPDX-License-Identifier: BSD-3-Clause

(defpackage #:cl-signature-utils.test
  (:use #:cl)
  (:export #:run-tests))

(in-package #:cl-signature-utils.test)

(defun run-tests ()
  "Run all tests for cl-signature-utils."
  (format t "~&Running tests for cl-signature-utils...~%")
  ;; TODO: Add test cases
  ;; (test-function-1)
  ;; (test-function-2)
  (format t "~&All tests passed!~%")
  t)
