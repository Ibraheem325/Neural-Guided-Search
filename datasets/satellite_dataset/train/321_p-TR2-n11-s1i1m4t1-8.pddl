(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	thermograph1 - mode
	infrared3 - mode
	thermograph2 - mode
	GroundStation0 - direction
	Planet1 - direction
	Star2 - direction
	Phenomenon3 - direction
	Phenomenon4 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared3)
	(supports instrument0 image0)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet1)
)
(:goal (and
	(have_image Planet1 thermograph2)
	(have_image Star2 infrared3)
	(have_image Phenomenon3 infrared3)
	(have_image Phenomenon4 thermograph2)
))

)
