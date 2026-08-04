(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	image0 - mode
	GroundStation0 - direction
	Star2 - direction
	Star3 - direction
	Star4 - direction
	Star5 - direction
	Star7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	Star13 - direction
	GroundStation14 - direction
	GroundStation15 - direction
	Star16 - direction
	Star20 - direction
	GroundStation21 - direction
	Star22 - direction
	Star23 - direction
	Star24 - direction
	Star25 - direction
	GroundStation26 - direction
	Star27 - direction
	GroundStation29 - direction
	Star30 - direction
	Star31 - direction
	GroundStation32 - direction
	GroundStation33 - direction
	Star34 - direction
	Star35 - direction
	GroundStation36 - direction
	GroundStation37 - direction
	Star38 - direction
	Star39 - direction
	GroundStation40 - direction
	Star41 - direction
	GroundStation42 - direction
	Star43 - direction
	Star44 - direction
	Star45 - direction
	GroundStation46 - direction
	Star47 - direction
	Star48 - direction
	GroundStation49 - direction
	GroundStation50 - direction
	Star51 - direction
	Star52 - direction
	Star53 - direction
	Star54 - direction
	GroundStation55 - direction
	Star56 - direction
	Star57 - direction
	GroundStation58 - direction
	Star61 - direction
	Star62 - direction
	GroundStation63 - direction
	GroundStation64 - direction
	Star65 - direction
	Star67 - direction
	Star68 - direction
	GroundStation69 - direction
	Star70 - direction
	GroundStation71 - direction
	GroundStation59 - direction
	GroundStation66 - direction
	GroundStation17 - direction
	GroundStation60 - direction
	GroundStation1 - direction
	GroundStation28 - direction
	Star18 - direction
	Star6 - direction
	GroundStation19 - direction
	Star72 - direction
	Planet73 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation66)
	(calibration_target instrument0 GroundStation59)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star25)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation19)
	(calibration_target instrument1 Star18)
	(calibration_target instrument1 GroundStation28)
	(calibration_target instrument1 GroundStation1)
	(calibration_target instrument1 GroundStation60)
	(calibration_target instrument1 GroundStation17)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star27)
	(supports instrument2 image0)
	(calibration_target instrument2 GroundStation19)
	(calibration_target instrument2 Star6)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation55)
)
(:goal (and
	(pointing satellite1 Star68)
	(have_image Star72 image0)
	(have_image Planet73 image0)
))

)
