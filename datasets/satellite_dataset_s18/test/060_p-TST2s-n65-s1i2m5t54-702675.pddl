(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	infrared2 - mode
	image3 - mode
	image1 - mode
	infrared4 - mode
	image0 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	GroundStation8 - direction
	GroundStation10 - direction
	Star11 - direction
	Star12 - direction
	Star13 - direction
	GroundStation14 - direction
	GroundStation16 - direction
	GroundStation17 - direction
	GroundStation18 - direction
	Star19 - direction
	GroundStation20 - direction
	GroundStation21 - direction
	GroundStation22 - direction
	Star23 - direction
	Star24 - direction
	Star25 - direction
	GroundStation26 - direction
	Star28 - direction
	Star29 - direction
	Star30 - direction
	GroundStation33 - direction
	GroundStation34 - direction
	Star35 - direction
	Star37 - direction
	Star39 - direction
	Star40 - direction
	GroundStation42 - direction
	Star43 - direction
	GroundStation44 - direction
	GroundStation45 - direction
	GroundStation46 - direction
	GroundStation49 - direction
	GroundStation50 - direction
	Star51 - direction
	GroundStation52 - direction
	GroundStation53 - direction
	Star3 - direction
	GroundStation41 - direction
	Star48 - direction
	Star31 - direction
	Star9 - direction
	GroundStation5 - direction
	Star32 - direction
	GroundStation27 - direction
	Star15 - direction
	GroundStation36 - direction
	GroundStation47 - direction
	GroundStation7 - direction
	Star38 - direction
	Planet54 - direction
	Phenomenon55 - direction
	Planet56 - direction
)
(:init
	(supports instrument0 infrared4)
	(supports instrument0 infrared2)
	(supports instrument0 image1)
	(supports instrument0 image3)
	(calibration_target instrument0 GroundStation47)
	(calibration_target instrument0 GroundStation36)
	(calibration_target instrument0 Star15)
	(calibration_target instrument0 GroundStation27)
	(calibration_target instrument0 Star32)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 Star31)
	(calibration_target instrument0 Star48)
	(calibration_target instrument0 GroundStation41)
	(calibration_target instrument0 Star3)
	(supports instrument1 infrared2)
	(supports instrument1 image0)
	(calibration_target instrument1 Star38)
	(calibration_target instrument1 GroundStation7)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation5)
)
(:goal (and
	(have_image Planet54 image0)
	(have_image Phenomenon55 image0)
	(have_image Planet56 infrared2)
))

)
