;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: BSD-3-Clause

;;;; cl-signature-utils.asd
;;;; Signature encoding helpers
;;;; Copyright (c) 2024-2026 Parkian Company LLC

(asdf:defsystem #:cl-signature-utils
  :description "Signature encoding helpers (DER, compact, recovery)"
  :author "Park Ian Co"
  :license "Apache-2.0"
  :version "0.1.0"
  :serial t
  :components ((:file "package")
               (:module "src"
                :components ((:file "package")
                             (:file "conditions" :depends-on ("package"))
                             (:file "types" :depends-on ("package"))
                             (:file "cl-signature-utils" :depends-on ("package" "conditions" "types")))))))

(asdf:defsystem #:cl-signature-utils/test
  :description "Tests for cl-signature-utils"
  :depends-on (#:cl-signature-utils)
  :serial t
  :components ((:module "test"
                :components ((:file "test-signature-utils"))))
  :perform (asdf:test-op (o c)
             (let ((result (uiop:symbol-call :cl-signature-utils.test :run-tests)))
               (unless result
                 (error "Tests failed")))))
