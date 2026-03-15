;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: Apache-2.0

;;;; package.lisp
;;;; Package definition for cl-signature-utils
;;;; Copyright (c) 2024-2026 Parkian Company LLC

(defpackage #:cl-signature-utils
  (:use #:cl)
  (:export
   #:deep-copy-list
   #:group-by-count
   #:identity-list
   #:flatten
   #:map-keys
   #:now-timestamp
#:with-signature-utils-timing
   #:signature-utils-batch-process
   #:signature-utils-health-check;; Signature encoding
   #:der-encode-signature
   #:der-decode-signature
   #:compact-signature
   #:signature-recovery
   #:normalize-signature))
