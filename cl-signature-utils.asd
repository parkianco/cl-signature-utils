;;;; cl-signature-utils.asd
;;;; Signature encoding helpers
;;;; Copyright (c) 2024-2026 Parkian Company LLC

(asdf:defsystem #:cl-signature-utils
  :description "Signature encoding helpers (DER, compact, recovery)"
  :author "Parkian Company LLC"
  :license "BSD-3-Clause"
  :version "1.0.0"
  :serial t
  :components ((:file "package")
               (:module "src"
                :components ((:file "signature-utils")))))
