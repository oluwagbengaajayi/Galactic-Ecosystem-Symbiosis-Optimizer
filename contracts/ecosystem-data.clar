;; Ecosystem Data Management Contract

(define-data-var ecosystem-counter uint u0)

(define-map ecosystems uint {
  planet: (string-ascii 50),
  biome: (string-ascii 50),
  dominant-species: (string-ascii 100),
  climate: (string-ascii 50),
  biodiversity-index: uint,
  stability-score: uint,
  last-updated: uint
})

(define-public (register-ecosystem (planet (string-ascii 50)) (biome (string-ascii 50)) (dominant-species (string-ascii 100)) (climate (string-ascii 50)) (biodiversity-index uint) (stability-score uint))
  (let
      ((new-id (+ (var-get ecosystem-counter) u1)))
      (map-set ecosystems new-id {
          planet: planet,
          biome: biome,
          dominant-species: dominant-species,
          climate: climate,
          biodiversity-index: biodiversity-index,
          stability-score: stability-score,
          last-updated: block-height
      })
      (var-set ecosystem-counter new-id)
      (ok new-id)
  )
)

(define-public (update-ecosystem (ecosystem-id uint) (biodiversity-index uint) (stability-score uint))
  (let
      ((ecosystem (unwrap! (map-get? ecosystems ecosystem-id) (err u404))))
      (ok (map-set ecosystems ecosystem-id
          (merge ecosystem {
              biodiversity-index: biodiversity-index,
              stability-score: stability-score,
              last-updated: block-height
          })))
  )
)

(define-read-only (get-ecosystem (ecosystem-id uint))
  (map-get? ecosystems ecosystem-id)
)

(define-read-only (get-ecosystem-count)
  (var-get ecosystem-counter)
)

