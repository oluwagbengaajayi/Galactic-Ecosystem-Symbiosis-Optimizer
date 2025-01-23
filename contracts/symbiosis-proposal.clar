;; Symbiosis Proposal Contract

(define-data-var proposal-counter uint u0)

(define-map symbiosis-proposals uint {
  proposer: principal,
  ecosystem-a: uint,
  ecosystem-b: uint,
  description: (string-utf8 500),
  potential-benefit: uint,
  status: (string-ascii 20),
  votes: uint,
  created-at: uint
})

(define-public (create-proposal (ecosystem-a uint) (ecosystem-b uint) (description (string-utf8 500)) (potential-benefit uint))
  (let
      ((new-id (+ (var-get proposal-counter) u1)))
      (map-set symbiosis-proposals new-id {
          proposer: tx-sender,
          ecosystem-a: ecosystem-a,
          ecosystem-b: ecosystem-b,
          description: description,
          potential-benefit: potential-benefit,
          status: "proposed",
          votes: u0,
          created-at: block-height
      })
      (var-set proposal-counter new-id)
      (ok new-id)
  )
)

(define-public (vote-proposal (proposal-id uint))
  (let
      ((proposal (unwrap! (map-get? symbiosis-proposals proposal-id) (err u404))))
      (ok (map-set symbiosis-proposals proposal-id
          (merge proposal { votes: (+ (get votes proposal) u1) })))
  )
)

(define-public (update-proposal-status (proposal-id uint) (new-status (string-ascii 20)))
  (let
      ((proposal (unwrap! (map-get? symbiosis-proposals proposal-id) (err u404))))
      (asserts! (is-eq tx-sender (get proposer proposal)) (err u403))
      (ok (map-set symbiosis-proposals proposal-id
          (merge proposal { status: new-status })))
  )
)

(define-read-only (get-proposal (proposal-id uint))
  (map-get? symbiosis-proposals proposal-id)
)

(define-read-only (get-proposal-count)
  (var-get proposal-counter)
)

