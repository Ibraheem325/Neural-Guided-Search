(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph2 - mode
	thermograph4 - mode
	infrared3 - mode
	thermograph1 - mode
	thermograph0 - mode
	GroundStation0 - direction
	Phenomenon1 - direction
	Planet2 - direction
	Star3 - direction
	Phenomenon4 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 infrared3)
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph1)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet2)
)
(:goal (and
	(pointing satellite0 Phenomenon4)
	(have_image Phenomenon1 thermograph0)
	(have_image Planet2 infrared3)
	(have_image Star3 thermograph2)
	(have_image Phenomenon4 thermograph4)
))

)
