(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	image1 - mode
	thermograph3 - mode
	thermograph0 - mode
	GroundStation0 - direction
	Phenomenon1 - direction
	Planet2 - direction
	Planet3 - direction
	Star4 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 image1)
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph3)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet2)
)
(:goal (and
	(pointing satellite0 Planet3)
	(have_image Phenomenon1 image1)
	(have_image Planet2 image1)
	(have_image Planet3 image1)
	(have_image Star4 thermograph3)
))

)
