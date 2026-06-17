(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	thermograph2 - mode
	thermograph1 - mode
	infrared3 - mode
	GroundStation1 - direction
	GroundStation0 - direction
	Planet2 - direction
	Star3 - direction
	Star4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared3)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
)
(:goal (and
	(have_image Planet2 infrared3)
	(have_image Star3 infrared3)
	(have_image Star4 image0)
	(have_image Planet5 thermograph1)
))

)
