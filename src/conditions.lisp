;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: Apache-2.0

(in-package #:cl-signature-utils)

(define-condition cl-signature-utils-error (error)
  ((message :initarg :message :reader cl-signature-utils-error-message))
  (:report (lambda (condition stream)
             (format stream "cl-signature-utils error: ~A" (cl-signature-utils-error-message condition)))))
