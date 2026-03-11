# cl-signature-utils

Signature encoding helpers for Common Lisp.

## Features

- DER encoding/decoding for ECDSA signatures
- Compact signature format (64 bytes)
- Recoverable signatures (65 bytes with recovery ID)
- Low-S normalization (BIP62)
- Zero external dependencies

## Installation

```lisp
(asdf:load-system :cl-signature-utils)
```

## Usage

```lisp
(use-package :cl-signature-utils)

;; DER encoding
(der-encode-signature r s)
(multiple-value-bind (r s) (der-decode-signature der-bytes)
  (process r s))

;; Compact format (64 bytes)
(compact-signature r s)

;; Recoverable signature (65 bytes)
(compact-signature r s 0)  ; With recovery ID

;; Extract from recoverable
(multiple-value-bind (r s recovery-id)
    (signature-recovery compact-sig)
  (recover-pubkey r s recovery-id message))

;; Normalize to low-S (BIP62)
(multiple-value-bind (r s normalized-p)
    (normalize-signature r s)
  (when normalized-p
    (format t "Signature was normalized~%")))
```

## API

- `der-encode-signature r s` - Encode to DER format
- `der-decode-signature der-bytes` - Decode DER to (values r s)
- `compact-signature r s &optional recovery-id` - Create compact signature
- `signature-recovery compact-sig` - Extract r, s, recovery-id
- `normalize-signature r s` - Normalize to low-S form

## Formats

- **DER**: Variable length, ASN.1 encoding (Bitcoin transactions)
- **Compact**: Fixed 64 bytes (r || s)
- **Recoverable**: 65 bytes (v || r || s) with recovery ID

## License

BSD-3-Clause. Copyright (c) 2024-2026 Parkian Company LLC
