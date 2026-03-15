;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: Apache-2.0

(in-package #:cl-signature-utils)

;;; Core types for cl-signature-utils
(deftype cl-signature-utils-id () '(unsigned-byte 64))
(deftype cl-signature-utils-status () '(member :ready :active :error :shutdown))
