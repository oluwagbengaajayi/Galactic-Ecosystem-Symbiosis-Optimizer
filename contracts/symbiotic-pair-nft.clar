;; Symbiotic Pair NFT Contract

(define-non-fungible-token symbiotic-pair uint)

(define-data-var last-token-id uint u0)

(define-map token-metadata uint {
  name: (string-ascii 100),
  description: (string-utf8 500),
  ecosystem-a: uint,
  ecosystem-b: uint,
  symbiosis-strength: uint,
  creator: principal,
  creation-date: uint
})

(define-public (mint-symbiotic-pair (name (string-ascii 100)) (description (string-utf8 500)) (ecosystem-a uint) (ecosystem-b uint) (symbiosis-strength uint))
  (let
      ((token-id (+ (var-get last-token-id) u1)))
      (try! (nft-mint? symbiotic-pair token-id tx-sender))
      (map-set token-metadata token-id {
          name: name,
          description: description,
          ecosystem-a: ecosystem-a,
          ecosystem-b: ecosystem-b,
          symbiosis-strength: symbiosis-strength,
          creator: tx-sender,
          creation-date: block-height
      })
      (var-set last-token-id token-id)
      (ok token-id)
  )
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (begin
      (asserts! (is-eq tx-sender sender) (err u403))
      (nft-transfer? symbiotic-pair token-id sender recipient)
  )
)

(define-read-only (get-token-metadata (token-id uint))
  (map-get? token-metadata token-id)
)

(define-read-only (get-last-token-id)
  (var-get last-token-id)
)

