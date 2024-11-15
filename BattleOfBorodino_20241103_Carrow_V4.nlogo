patches-own [terrain-type ranged-attack-damage-modifier ranged-attack-range-modifier damage-reduction-modifier movement-modifier can-enter]

;; Global Variables
globals [
  french-dead
  russian-dead
  french-total-units
  russian-total-units
  total-bullets ;; Track total bullets fired
  health-loss-rate ;; health loss over time

]

;; Define each unit breed type.
breed [french-infantry single-french-infantry]
breed [french-cavalry single-french-cavalry]
breed [french-cannons single-french-cannon]
breed [french-howitzers single-french-howitzer]

breed [russian-infantry single-russian-infantry]
breed [russian-cavalry single-russian-cavalry]
breed [russian-cannons single-russian-cannon]
breed [russian-howitzers single-russian-howitzer]

breed [bullets a-bullet]



;; Define additional properties specific to French and Russian forces
french-infantry-own [health side speed max-range ph cone-size]
french-cavalry-own [health side speed max-range ph cone-size]
french-cannons-own [health side speed max-range ph cone-size]
french-howitzers-own [health side speed max-range ph cone-size]

russian-infantry-own [health side speed max-range ph cone-size]
russian-cavalry-own [health side speed max-range ph cone-size]
russian-cannons-own [health side speed max-range ph cone-size]
russian-howitzers-own [health side speed max-range ph cone-size]

to setup
  clear-all
  setup-terrain
  reset-ticks

  set french-dead 0
  set french-total-units 0

  set russian-dead 0
  set russian-total-units 0


  ;; Define field boundaries for positioning
  let field-width max-pxcor - min-pxcor
  let french-side min-pxcor + (field-width / 4) ;; French positioned on the left side
  let russian-side max-pxcor - (field-width / 4) ;; Russians positioned on the right side

  ;; Create French units with initial properties
  create-french-infantry 208 [
    set color blue
    set side "french"
    set health 100
    set speed 0.2
    set max-range 10
    set cone-size 120
    set shape "person"
    setxy -10 random-ycor ;; Positions along the left side
    set heading 90 ;; Faces towards the right side (90 degrees)

  ]
  ;; Initialize Health Loss Rate
  set health-loss-rate 0.05

  create-french-cavalry 26 [
    set color blue
    set side "french"
    set health 100
    set speed 0.2
    set max-range 10
    set cone-size 120
    set shape "wolf"
    setxy -8 random-ycor ;; Positions along the left side
    set heading 90 ;; Faces towards the right side (90 degrees)
  ]

  create-french-cannons 13 [
    set color blue
    set side "french"
    set health 600
    set speed 0.2
    set max-range 10
    set cone-size 120
    set shape "cannon"
    setxy -6 random-ycor ;; Positions along the left side
    set heading 90 ;; Faces towards the right side (90 degrees)
  ]

  create-french-howitzers 13 [
    set color blue
    set side "french"
    set health 600
    set speed 0.2
    set max-range 10
    set cone-size 120
    set shape "cannon carriage"
    setxy -4 random-ycor ;; Positions along the left side
    set heading 90 ;; Faces towards the right side (90 degrees)
  ]


  ;; Create Russian infantry with initial properties
  create-russian-infantry 202 [
    set color red
    set side "russian"
    set health 100
    set speed 0.2
    set max-range 10
    set cone-size 120
    set shape "person"
    setxy 10 random-ycor ;; Positions along the right side
    set heading 270 ;; Faces towards the left side (270 degrees)
  ]

  create-russian-cavalry 24 [
    set color red
    set side "russian"
    set health 100
    set speed 0.2
    set max-range 10
    set cone-size 120
    set shape "wolf"
    setxy 8 random-ycor ;; Positions along the right side
    set heading 270 ;; Faces towards the left side (270 degrees)
  ]

  create-russian-cannons 7 [
    set color red
    set side "russian"
    set health 600
    set speed 0.2
    set max-range 10
    set cone-size 120
    set shape "cannon"
    setxy 6 random-ycor ;; Positions along the right side
    set heading 270 ;; Faces towards the left side (270 degrees)
  ]

  create-russian-howitzers 7 [
    set color red
    set side "russian"
    set health 600
    set speed 0.2
    set max-range 10
    set cone-size 120
    set shape "cannon carriage"
    setxy 4 random-ycor ;; Positions along the right side
    set heading 270 ;; Faces towards the left side (270 degrees)
  ]


  set french-total-units french-total-units + count turtles with [side = "french"]
  set russian-total-units russian-total-units + count turtles with [side = "russian"]



  reset-ticks ;; Resets tick counter to zero
end

to setup-terrain
  ask patches [
    ;; Assign terrain types randomly (for now)
    ;; let random-value random 100
    ;; if random-value < 50 [ set terrain-type "Flat Plains" ]
    ;; if random-value >= 50 and random-value < 65 [ set terrain-type "River" ]
    ;; if random-value >= 65 and random-value < 85 [ set terrain-type "Forest" ]
    ;; if random-value >= 85 [ set terrain-type "Hill" ]

    ;; (y = 20)
    ask patches with [pycor = 20] [
      if pxcor < -10 [ set terrain-type "Forest" ]
      if pxcor >= -10 and pxcor < -5 [ set terrain-type "Flat Plains" ]
      if pxcor >= -5 and pxcor < 5 [ set terrain-type "Forest" ]
      if pxcor >= 5 and pxcor < 18 [ set terrain-type "Flat Plains" ]
      if pxcor >= 18 and pxcor < 27 [ set terrain-type "River" ]
      if pxcor >= 27 [ set terrain-type "Flat Plains" ]
    ]

    ask patches with [pycor = 19] [
      if pxcor < -9 [ set terrain-type "Forest" ]
      if pxcor >= -9 and pxcor < -4 [ set terrain-type "Flat Plains" ]
      if pxcor >= -4 and pxcor < 4 [ set terrain-type "Forest" ]
      if pxcor >= 4 and pxcor < 25 [ set terrain-type "Flat Plains" ]
      if pxcor >= 25 and pxcor < 27 [ set terrain-type "River" ]
      if pxcor >= 27 [ set terrain-type "Flat Plains" ]

      if pxcor = 19 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = 18] [
      if pxcor < -8 [ set terrain-type "Forest" ]
      if pxcor >= -8 and pxcor < -3 [ set terrain-type "Flat Plains" ]
      if pxcor >= -3 and pxcor < 3 [ set terrain-type "Forest" ]
      if pxcor >= 3 and pxcor < 21 [ set terrain-type "Flat Plains" ]
      if pxcor >= 21 and pxcor < 25 [ set terrain-type "Forest" ]
      if pxcor = 25 [ set terrain-type "Flat Plains" ]
      if pxcor >= 26 and pxcor < 27 [ set terrain-type "River" ]
      if pxcor >= 27 [ set terrain-type "Flat Plains" ]

      if pxcor = 19 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = 17] [
      if pxcor < -8 [ set terrain-type "Forest" ]
      if pxcor >= -8 and pxcor < -1 [ set terrain-type "Flat Plains" ]
      if pxcor >= -1 and pxcor < 1 [ set terrain-type "Forest" ]
      if pxcor >= 1 and pxcor < 21 [ set terrain-type "Flat Plains" ]
      if pxcor >= 21 and pxcor < 25 [ set terrain-type "Forest" ]
      if pxcor = 25 [ set terrain-type "Flat Plains" ]
      if pxcor >= 26 and pxcor < 27 [ set terrain-type "River" ]
      if pxcor >= 27 [ set terrain-type "Flat Plains" ]

      if pxcor = 19 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = 16] [
      if pxcor < -9 [ set terrain-type "Forest" ]
      if pxcor >= -9 and pxcor < 1 [ set terrain-type "Flat Plains" ]
      if pxcor >= 1 and pxcor < 21 [ set terrain-type "Flat Plains" ]
      if pxcor >= 21 and pxcor < 25 [ set terrain-type "Forest" ]
      if pxcor = 25 [ set terrain-type "Flat Plains" ]
      if pxcor >= 26 and pxcor < 27 [ set terrain-type "River" ]
      if pxcor >= 27 [ set terrain-type "Flat Plains" ]

      if pxcor = 14 [ set terrain-type "River" ]
      if pxcor = 15 [ set terrain-type "River" ]
      if pxcor = 16 [ set terrain-type "River" ]
      if pxcor = 19 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = 15] [
      if pxcor < -10 [ set terrain-type "Forest" ]
      if pxcor >= -10 and pxcor < 1 [ set terrain-type "Flat Plains" ]
      if pxcor >= 1 and pxcor < 21 [ set terrain-type "Flat Plains" ]
      if pxcor >= 22 and pxcor < 25 [ set terrain-type "Forest" ]
      if pxcor = 25 [ set terrain-type "Flat Plains" ]
      if pxcor >= 26 and pxcor < 27 [ set terrain-type "River" ]
      if pxcor >= 27 [ set terrain-type "Flat Plains" ]

      if pxcor = 13 [ set terrain-type "River" ]
      if pxcor = 14 [ set terrain-type "River" ]

      if pxcor = 16 [ set terrain-type "River" ]
      if pxcor = 17 [ set terrain-type "River" ]
      if pxcor = 19 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = 14] [
      if pxcor < -13 [ set terrain-type "Forest" ]
      if pxcor >= -13 and pxcor < 1 [ set terrain-type "Flat Plains" ]
      if pxcor >= 1 and pxcor < 22 [ set terrain-type "Flat Plains" ]
      if pxcor >= 22 and pxcor < 25 [ set terrain-type "Forest" ]
      if pxcor = 25 [ set terrain-type "Flat Plains" ]
      if pxcor >= 26 and pxcor < 27 [ set terrain-type "River" ]
      if pxcor >= 27 [ set terrain-type "Flat Plains" ]

      if pxcor = 12 [ set terrain-type "River" ]
      if pxcor = 13 [ set terrain-type "River" ]

      if pxcor = 17 [ set terrain-type "River" ]
      if pxcor = 18 [ set terrain-type "River" ]
      if pxcor = 19 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = 13] [
      if pxcor < -14 [ set terrain-type "Forest" ]
      if pxcor >= -14 and pxcor < 16 [ set terrain-type "Flat Plains" ]
      if pxcor >= 16 [ set terrain-type "Flat Plains" ]

      if pxcor = 10 [ set terrain-type "River" ]
      if pxcor = 11 [ set terrain-type "River" ]
      if pxcor = 12 [ set terrain-type "River" ]

      if pxcor = 26 [ set terrain-type "River" ]
      if pxcor = 27 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = 12] [
      if pxcor < -16 [ set terrain-type "Forest" ]
      if pxcor >= -16 and pxcor < 16 [ set terrain-type "Flat Plains" ]
      if pxcor >= 16 and pxcor < 19 [ set terrain-type "Hill" ]
      if pxcor >= 19 [ set terrain-type "Flat Plains" ]

      if pxcor = 8 [ set terrain-type "River" ]
      if pxcor = 9 [ set terrain-type "River" ]
      if pxcor = 10 [ set terrain-type "River" ]

      if pxcor = 27 [ set terrain-type "River" ]
      if pxcor = 28 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = 11] [
      if pxcor < -17 [ set terrain-type "Forest" ]
      if pxcor >= -17 and pxcor < 16 [ set terrain-type "Flat Plains" ]
      if pxcor >= 16 and pxcor < 19 [ set terrain-type "Hill" ]
      if pxcor >= 19 [ set terrain-type "Flat Plains" ]

      if pxcor = 6 [ set terrain-type "River" ]
      if pxcor = 7 [ set terrain-type "River" ]
      if pxcor = 8 [ set terrain-type "River" ]

      if pxcor = 28 [ set terrain-type "River" ]
      if pxcor = 29 [ set terrain-type "River" ]
      if pxcor = 30 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = 10] [
      if pxcor < -20 [ set terrain-type "Forest" ]
      if pxcor >= -20 and pxcor < 16 [ set terrain-type "Flat Plains" ]
      if pxcor >= 16 and pxcor < 18 [ set terrain-type "Hill" ]
      if pxcor >= 18 [ set terrain-type "Flat Plains" ]

      if pxcor = 4 [ set terrain-type "River" ]
      if pxcor = 5 [ set terrain-type "River" ]
      if pxcor = 6 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = 9] [
      if pxcor < -22 [ set terrain-type "Forest" ]
      if pxcor >= -22 [ set terrain-type "Flat Plains" ]

      if pxcor = 2 [ set terrain-type "River" ]
      if pxcor = 3 [ set terrain-type "River" ]
      if pxcor = 4 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = 8] [
      if pxcor < -25 [ set terrain-type "Forest" ]
      if pxcor >= -25 [ set terrain-type "Flat Plains" ]

      if pxcor = 0 [ set terrain-type "River" ]
      if pxcor = 1 [ set terrain-type "River" ]
      if pxcor = 2 [ set terrain-type "River" ]
    ]


    ask patches with [pycor = 7] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor = -4 [ set terrain-type "River" ]
      if pxcor = -3 [ set terrain-type "River" ]
      if pxcor = -2 [ set terrain-type "Bridge" ]
      if pxcor = -1 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = 6] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor = -6 [ set terrain-type "River" ]
      if pxcor = -5 [ set terrain-type "River" ]
      if pxcor = -4 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = 5] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor = -8 [ set terrain-type "River" ]
      if pxcor = -7 [ set terrain-type "Bridge" ]
      if pxcor = -6 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = 4] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor = -10 [ set terrain-type "River" ]
      if pxcor = -9 [ set terrain-type "River" ]
      if pxcor = -8 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = 3] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor = -12 [ set terrain-type "River" ]
      if pxcor = -11 [ set terrain-type "River" ]
      if pxcor = -10 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = 2] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor = -2 [ set terrain-type "Hill" ]
      if pxcor = -1 [ set terrain-type "Hill" ]
      if pxcor = -0 [ set terrain-type "Hill" ]

      if pxcor = -7 [ set terrain-type "Hill" ]
      if pxcor = -6 [ set terrain-type "Hill" ]
      if pxcor = -5 [ set terrain-type "Hill" ]

      if pxcor = -14 [ set terrain-type "River" ]
      if pxcor = -13 [ set terrain-type "River" ]
      if pxcor = -12 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = 1] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -1 and pxcor <= 2 [ set terrain-type "Hill" ]

      if pxcor = -8 [ set terrain-type "Hill" ]
      if pxcor = -7 [ set terrain-type "Hill" ]
      if pxcor = -6 [ set terrain-type "Hill" ]
      if pxcor = -5 [ set terrain-type "Hill" ]
      if pxcor = -4 [ set terrain-type "Hill" ]

      if pxcor = -16 [ set terrain-type "River" ]
      if pxcor = -15 [ set terrain-type "River" ]
      if pxcor = -14 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = 0] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= 0 and pxcor <= 5 [ set terrain-type "Hill" ]

      if pxcor = -8 [ set terrain-type "Hill" ]
      if pxcor = -7 [ set terrain-type "Hill" ]
      if pxcor = -6 [ set terrain-type "Hill" ]
      if pxcor = -5 [ set terrain-type "Hill" ]
      if pxcor = -4 [ set terrain-type "Hill" ]

      if pxcor = -18 [ set terrain-type "River" ]
      if pxcor = -17 [ set terrain-type "River" ]
      if pxcor = -16 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = -1] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= 0 and pxcor <= 8 [ set terrain-type "Hill" ]

      if pxcor = -8 [ set terrain-type "Hill" ]
      if pxcor = -7 [ set terrain-type "Hill" ]
      if pxcor = -6 [ set terrain-type "Hill" ]
      if pxcor = -5 [ set terrain-type "Hill" ]
      if pxcor = -4 [ set terrain-type "Hill" ]

      if pxcor = -20 [ set terrain-type "River" ]
      if pxcor = -19 [ set terrain-type "River" ]
      if pxcor = -18 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = -2] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -1 and pxcor <= 10 [ set terrain-type "Hill" ]

      if pxcor = -7 [ set terrain-type "Hill" ]
      if pxcor = -6 [ set terrain-type "Hill" ]
      if pxcor = -5 [ set terrain-type "Hill" ]

      if pxcor >= -17 and pxcor <= -13 [ set terrain-type "Hill" ]

      if pxcor = -22 [ set terrain-type "River" ]
      if pxcor = -21 [ set terrain-type "River" ]
      if pxcor = -20 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = -3] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -2 and pxcor <= 11 [ set terrain-type "Hill" ]

      if pxcor >= -19 and pxcor <= -14 [ set terrain-type "Hill" ]

      if pxcor = -24 [ set terrain-type "River" ]
      if pxcor = -23 [ set terrain-type "River" ]
      if pxcor = -22 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = -4] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -3 and pxcor <= 11 [ set terrain-type "Hill" ]

      if pxcor >= -21 and pxcor <= -14 [ set terrain-type "Hill" ]

      if pxcor = -26 [ set terrain-type "River" ]
      if pxcor = -25 [ set terrain-type "River" ]
      if pxcor = -24 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = -5] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -4 and pxcor <= 13 [ set terrain-type "Hill" ]

      if pxcor >= -22 and pxcor <= -14 [ set terrain-type "Hill" ]

      if pxcor = -28 [ set terrain-type "River" ]
      if pxcor = -27 [ set terrain-type "River" ]
      if pxcor = -26 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = -6] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -4 and pxcor <= 12 [ set terrain-type "Hill" ]

      if pxcor >= -23 and pxcor <= -15 [ set terrain-type "Hill" ]

      if pxcor = -30 [ set terrain-type "River" ]
      if pxcor = -29 [ set terrain-type "River" ]
      if pxcor = -28 [ set terrain-type "River" ]
    ]

    ask patches with [pycor = -7] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -3 and pxcor <= 10 [ set terrain-type "Hill" ]

      if pxcor >= -23 and pxcor <= -15 [ set terrain-type "Hill" ]
    ]

    ask patches with [pycor = -8] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -2 and pxcor <= 8 [ set terrain-type "Hill" ]

      if pxcor >= -24 and pxcor <= -15 [ set terrain-type "Hill" ]
    ]

    ask patches with [pycor = -9] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -7 and pxcor <= -7 [ set terrain-type "Hill" ]

      if pxcor >= -1 and pxcor <= 6 [ set terrain-type "Hill" ]

      if pxcor >= -24 and pxcor <= -16 [ set terrain-type "Hill" ]
    ]

    ask patches with [pycor = -10] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -9 and pxcor <= -6 [ set terrain-type "Hill" ]

      if pxcor >= 0 and pxcor <= 3 [ set terrain-type "Hill" ]

      if pxcor >= -24 and pxcor <= -16 [ set terrain-type "Hill" ]
    ]

    ask patches with [pycor = -11] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -10 and pxcor <= -5 [ set terrain-type "Hill" ]

      if pxcor >= 1 and pxcor <= 2 [ set terrain-type "Hill" ]

      if pxcor >= -25 and pxcor <= -17 [ set terrain-type "Hill" ]
    ]

    ask patches with [pycor = -12] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -11 and pxcor <= -4 [ set terrain-type "Hill" ]

      if pxcor >= -25 and pxcor <= -17 [ set terrain-type "Hill" ]
    ]

    ask patches with [pycor = -13] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -12 and pxcor <= -3 [ set terrain-type "Hill" ]

      if pxcor >= -25 and pxcor <= -17 [ set terrain-type "Hill" ]
    ]

    ask patches with [pycor = -14] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -12 and pxcor <= -3 [ set terrain-type "Forest" ]

      if pxcor >= -25 and pxcor <= -17 [ set terrain-type "Hill" ]
    ]

    ask patches with [pycor = -15] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -13 and pxcor <= -2 [ set terrain-type "Forest" ]

      if pxcor >= -26 and pxcor <= -18 [ set terrain-type "Hill" ]
    ]

    ask patches with [pycor = -16] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -13 and pxcor <= -2 [ set terrain-type "Forest" ]

      if pxcor >= -26 and pxcor <= -18 [ set terrain-type "Hill" ]
    ]

    ask patches with [pycor = -17] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -14 and pxcor <= -1 [ set terrain-type "Forest" ]

      if pxcor >= -26 and pxcor <= -18 [ set terrain-type "Hill" ]
    ]

    ask patches with [pycor = -18] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -15 and pxcor <= 0 [ set terrain-type "Forest" ]

      if pxcor >= -26 and pxcor <= -18 [ set terrain-type "Hill" ]
    ]

    ask patches with [pycor = -19] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -16 and pxcor <= 1 [ set terrain-type "Forest" ]

      if pxcor >= -27 and pxcor <= -19 [ set terrain-type "Hill" ]
    ]

    ask patches with [pycor = -20] [
      if pxcor >= -30 [ set terrain-type "Flat Plains" ]

      if pxcor >= -17 and pxcor <= 2 [ set terrain-type "Forest" ]

      if pxcor >= -27 and pxcor <= -19 [ set terrain-type "Hill" ]
    ]

    ;; Apply terrain-specific movement penalties and cover bonuses
    if terrain-type = "Flat Plains" [
      set ranged-attack-damage-modifier 1 ;; 0% bonus ranged attack damage
      set ranged-attack-range-modifier 1 ;; 0% bonus ranged attack range
      set damage-reduction-modifier 1 ;; 0% damage reduction
      set movement-modifier 1  ;; 0% movement speed reduction
      set can-enter true
      set pcolor green + 1  ;; Color for flat plains
    ]

    if terrain-type = "Bridge" [
      set ranged-attack-damage-modifier 1 ;; 0% bonus ranged attack damage
      set ranged-attack-range-modifier 1 ;; 0% bonus ranged attack range
      set damage-reduction-modifier 1 ;; 0% damage reduction
      set movement-modifier 1  ;; 0% movement speed reduction
      set can-enter true
      set pcolor gray  ;; Color for bridge
    ]

    if terrain-type = "River" [
      set ranged-attack-damage-modifier 1 ;; 0% bonus ranged attack damage
      set ranged-attack-range-modifier 1 ;; 0% bonus ranged attack range
      set damage-reduction-modifier 1 ;; 0% damage reduction
      set movement-modifier 1  ;; 0% movement speed reduction
      set can-enter false
      set pcolor blue  ;; Color for rivers
    ]

    if terrain-type = "Forest" [
      set ranged-attack-damage-modifier 1 ;; 0% bonus ranged attack damage
      set ranged-attack-range-modifier 0.85 ;; 15% reduced ranged attack range
      set damage-reduction-modifier 1.30 ;; 30% damage reduction
      set movement-modifier 0.85  ;; 15% movement speed reduction
      set can-enter true
      set pcolor green - 2  ;; Darker green for forests
    ]

    if terrain-type = "Hill" [
      set ranged-attack-damage-modifier 1.1 ;; 10% bonus ranged attack damage
      set ranged-attack-range-modifier 1.2 ;; 20% bonus ranged attack range
      set damage-reduction-modifier 1.25 ;; 25% damage reduction
      set movement-modifier 0.7  ;; 30% movement speed reduction
      set can-enter true
      set pcolor brown  ;; Color for hills
    ]

    ;; set plabel (word "(" pycor " " pxcor ")")
  ]
end

to go
  ;; Move all units randomly (omitted for now)
  ask turtles [
    ;;right random 360
    set label word "HP: " precision health 0
    if health < route-health [ retreat ]  ;; INTERFACE SLIDER VAR - Execute a retreat when health is less than route-health global var. kai

    if can-move-? [
      let current-patch patch-here
      let terrain-modifier [movement-modifier] of current-patch
      fd speed * terrain-modifier
    ]
  ]

;;ask turtles [ set label word "Health: " health ]

  ;; Each side detects and attacks the other
  ask french-infantry [ detect-and-attack "russian" ]
  ask french-cavalry [ detect-and-attack "russian" ]
  ask french-cavalry [ flank ] ;; Call the flank procedure for cavalry
  ask french-cannons [ detect-and-attack "russian" ]
  ask french-howitzers [ detect-and-attack "russian"]

  ask russian-infantry [ detect-and-attack "french" ]
  ask russian-cavalry [ detect-and-attack "french" ]
  ask russian-cavalry [ flank ] ;; Call the flank procedure for Russian cavalry
  ask russian-cannons [ detect-and-attack "french" ]
  ask russian-howitzers [ detect-and-attack "french" ]

  ;; Health Loss
  lose-health
  speed-adj-health ;; change speed based on health loss


  ;; Remove any units with zero or less health
  ask turtles with [health <= 0] [
    ;; update counters for casualties
    if side = "french"[
     set french-dead french-dead + 1
     set french-total-units french-total-units - 1
    ]

    if side = "russian" [
    set russian-dead russian-dead + 1
    set russian-total-units russian-total-units - 1
    ]
    die

  ]
  ;; Stop the simulation if all troops are dead on one side
  if (french-total-units = 0 or russian-total-units = 0)[stop]


  tick ;; Increment the tick counter
end

to detect-and-attack [enemy-side]
  let current-patch patch-here
  let range-modifier [ranged-attack-range-modifier] of current-patch
  let damage-modifier [ranged-attack-damage-modifier] of current-patch
  let enemy turtles with [side = enemy-side]
  if any? enemy [
    let potential-targets enemy in-cone (max-range * range-modifier) cone-size
    ifelse any? potential-targets [
      let target min-one-of potential-targets [distance myself]
      ask target [
        set health health - (10 * damage-modifier) ;; Adjust damage based on terrain
      ]
    ] [
      let nearest-enemy min-one-of enemy [distance myself]
      face nearest-enemy
      fd speed
    ]
  ]
end

to-report can-move-?
  let current-patch patch-here
  report [can-enter] of current-patch
end

;; Cavalry flank kai
to flank
  let current-patch patch-here
  let terrain-modifier [movement-modifier] of current-patch
  let enemy-side ifelse-value (side = "french") ["russian"] ["french"]
  let enemy-units turtles with [side = enemy-side]
  let target one-of enemy-units
  if target != nobody [
    let flank-direction ifelse-value (random 2 = 0) [90] [-90]
    set heading (towards target + flank-direction)
    fd speed * terrain-modifier
    face target
  ]
end


;; If health is less than 30%, run from the battlefield and despawn. kai
to retreat
  ;; Store the original speed
  let original-speed speed

  ;; Increase speed for retreating based on the retreat-speed slider
  set speed original-speed * retreat-speed-multiplier

  ;; Find the nearest edge of the map
  let target-x ifelse-value (xcor > 0) [max-pxcor] [min-pxcor]
  let target-y ifelse-value (ycor > 0) [max-pycor] [min-pycor]

  ;; Move towards the nearest edge
  set heading towards patch target-x target-y
  fd speed ;; Move forward at the specified speed

  ;; Check if at the edge and then die
  if (xcor = target-x or ycor = target-y) [
    die ;; Remove the unit from the simulation
  ]


  ;; Restore original speed after retreating
  set speed original-speed
end

;; Health loss
to lose-health
  ask turtles [
    ;; Decrease health gradually over time
    set health health - health-loss-rate

    ;; Set health 0 if below
    if health < 0 [ set health 0 ]
  ]
end

;; Change speed based on health level
to speed-adj-health
  ask turtles [
    ;; Set a health ratio to calculate speed based on health
    let health-ratio health / 100

    ;; As health decreases, speed decreases
    set speed 0.1 + (0.3 * health-ratio)
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
469
26
1575
773
-1
-1
18.0
1
4
1
1
1
0
1
1
1
-30
30
-20
20
0
0
1
ticks
30.0

BUTTON
14
11
77
44
NIL
go\n
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
102
12
165
45
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
6
230
206
380
French Casualties 
Time (mins)
Troops
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot french-dead"

PLOT
207
230
407
380
Russian Casualties
Time (mins)
Troops
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot russian-dead\n"

MONITOR
7
178
100
223
French Troops
french-total-units
17
1
11

MONITOR
206
177
300
222
Russian Troops
russian-total-units
17
1
11

SLIDER
14
97
192
130
route-health
route-health
0
100
6.0
1
1
NIL
HORIZONTAL

SLIDER
14
56
192
89
retreat-speed-multiplier
retreat-speed-multiplier
1
5
1.5
.5
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

cannon
true
0
Polygon -7500403 true true 165 0 165 15 180 150 195 165 195 180 180 195 165 225 135 225 120 195 105 180 105 165 120 150 135 15 135 0
Line -16777216 false 120 150 180 150
Line -16777216 false 120 195 180 195
Line -16777216 false 165 15 135 15
Polygon -16777216 false false 165 0 135 0 135 15 120 150 105 165 105 180 120 195 135 225 165 225 180 195 195 180 195 165 180 150 165 15

cannon carriage
false
0
Circle -7500403 false true 105 105 90
Circle -7500403 false true 90 90 120
Line -7500403 true 180 120 120 180
Line -7500403 true 120 120 180 180
Line -7500403 true 150 105 150 195
Line -7500403 true 105 150 195 150
Polygon -7500403 false true 0 195 0 210 180 150 180 135

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
