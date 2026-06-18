(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	image5 - mode
	infrared1 - mode
	thermograph0 - mode
	image3 - mode
	infrared4 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation12 - direction
	GroundStation13 - direction
	Star7 - direction
	Planet14 - direction
	Star15 - direction
	Planet16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 infrared1)
	(supports instrument0 infrared4)
	(supports instrument0 image3)
	(supports instrument0 image5)
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star7)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation9)
)
(:goal (and
	(have_image Planet14 image5)
	(have_image Star15 infrared1)
	(have_image Planet16 infrared1)
	(have_image Planet17 infrared4)
	(have_image Planet17 infrared2)
))

)
