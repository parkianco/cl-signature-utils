;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: BSD-3-Clause

;;;; signature-utils.lisp
;;;; Signature encoding helpers
;;;; Copyright (c) 2024-2026 Parkian Company LLC

(in-package #:cl-signature-utils)

;;; secp256k1 curve order
(defconstant +secp256k1-n+
  #xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141)

(defconstant +secp256k1-half-n+
  (ash +secp256k1-n+ -1))

(defun bytes-to-integer (bytes)
  "Convert big-endian byte array to integer."
  (let ((result 0))
    (loop for b across bytes do
      (setf result (+ (ash result 8) b)))
    result))

(defun integer-to-bytes (n size)
  "Convert integer to big-endian byte array."
  (let ((result (make-array size :element-type '(unsigned-byte 8))))
    (loop for i from (1- size) downto 0 do
      (setf (aref result i) (logand n #xff))
      (setf n (ash n -8)))
    result))

(defun integer-to-der-bytes (n)
  "Convert integer to minimal DER-encoded bytes (with sign byte if needed)."
  (if (zerop n)
      (vector 0)
      (let* ((hex-len (ceiling (integer-length n) 8))
             (bytes (integer-to-bytes n hex-len)))
        ;; Add leading zero if high bit is set (to indicate positive)
        (if (>= (aref bytes 0) #x80)
            (concatenate '(vector (unsigned-byte 8)) #(0) bytes)
            bytes))))

(defun der-encode-signature (r s)
  "DER-encode an ECDSA signature.
   R, S: Either integers or 32-byte arrays.
   Returns DER-encoded signature as byte array."
  (let* ((r-int (etypecase r
                  (integer r)
                  (vector (bytes-to-integer r))))
         (s-int (etypecase s
                  (integer s)
                  (vector (bytes-to-integer s))))
         (r-bytes (integer-to-der-bytes r-int))
         (s-bytes (integer-to-der-bytes s-int))
         (r-len (length r-bytes))
         (s-len (length s-bytes))
         ;; Total length: 2 (r tag+len) + r-len + 2 (s tag+len) + s-len
         (content-len (+ 2 r-len 2 s-len))
         (result (make-array (+ 2 content-len) :element-type '(unsigned-byte 8))))
    ;; SEQUENCE tag
    (setf (aref result 0) #x30)
    (setf (aref result 1) content-len)
    ;; INTEGER tag for r
    (setf (aref result 2) #x02)
    (setf (aref result 3) r-len)
    (replace result r-bytes :start1 4)
    ;; INTEGER tag for s
    (setf (aref result (+ 4 r-len)) #x02)
    (setf (aref result (+ 5 r-len)) s-len)
    (replace result s-bytes :start1 (+ 6 r-len))
    result))

(defun der-decode-signature (der-bytes)
  "Decode a DER-encoded ECDSA signature.
   Returns (values r s) as integers."
  (unless (and (>= (length der-bytes) 8)
               (= (aref der-bytes 0) #x30))
    (error "Invalid DER signature: missing SEQUENCE tag"))
  (let ((total-len (aref der-bytes 1))
        (pos 2))
    (declare (ignore total-len))
    ;; Read r
    (unless (= (aref der-bytes pos) #x02)
      (error "Invalid DER signature: missing INTEGER tag for r"))
    (incf pos)
    (let* ((r-len (aref der-bytes pos))
           (_ (incf pos))
           (r-bytes (subseq der-bytes pos (+ pos r-len)))
           (r (bytes-to-integer r-bytes)))
      (declare (ignore _))
      (incf pos r-len)
      ;; Read s
      (unless (= (aref der-bytes pos) #x02)
        (error "Invalid DER signature: missing INTEGER tag for s"))
      (incf pos)
      (let* ((s-len (aref der-bytes pos))
             (_ (incf pos))
             (s-bytes (subseq der-bytes pos (+ pos s-len)))
             (s (bytes-to-integer s-bytes)))
        (declare (ignore _))
        (values r s)))))

(defun compact-signature (r s &optional recovery-id)
  "Create a 64-byte compact signature (r || s).
   Optionally prepend recovery ID for 65-byte recoverable signature.
   R, S: 32-byte arrays or integers.
   RECOVERY-ID: 0-3 for recoverable signatures, NIL for 64-byte compact."
  (let ((r-bytes (etypecase r
                   ((simple-array (unsigned-byte 8) (32)) r)
                   (integer (integer-to-bytes r 32))
                   (vector (if (= (length r) 32) r (error "R must be 32 bytes")))))
        (s-bytes (etypecase s
                   ((simple-array (unsigned-byte 8) (32)) s)
                   (integer (integer-to-bytes s 32))
                   (vector (if (= (length s) 32) s (error "S must be 32 bytes"))))))
    (if recovery-id
        (let ((result (make-array 65 :element-type '(unsigned-byte 8))))
          (setf (aref result 0) (+ 27 recovery-id))
          (replace result r-bytes :start1 1)
          (replace result s-bytes :start1 33)
          result)
        (concatenate '(vector (unsigned-byte 8)) r-bytes s-bytes))))

(defun signature-recovery (compact-sig)
  "Extract r, s, and recovery-id from a 65-byte recoverable signature.
   Returns (values r s recovery-id) where r, s are 32-byte arrays."
  (unless (= (length compact-sig) 65)
    (error "Recoverable signature must be 65 bytes"))
  (let* ((v (aref compact-sig 0))
         (recovery-id (- v 27))
         (r (subseq compact-sig 1 33))
         (s (subseq compact-sig 33 65)))
    (unless (<= 0 recovery-id 3)
      (error "Invalid recovery ID"))
    (values r s recovery-id)))

(defun normalize-signature (r s)
  "Normalize signature to low-S form (BIP62).
   If s > n/2, replace with n - s.
   Returns (values r s normalized-p)."
  (let ((r-int (etypecase r
                 (integer r)
                 (vector (bytes-to-integer r))))
        (s-int (etypecase s
                 (integer s)
                 (vector (bytes-to-integer s)))))
    (if (> s-int +secp256k1-half-n+)
        (values r-int (- +secp256k1-n+ s-int) t)
        (values r-int s-int nil))))
