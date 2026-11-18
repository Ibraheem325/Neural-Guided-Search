(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph1 - mode
	thermograph0 - mode
	GroundStation0 - direction
	Planet1 - direction
	Planet2 - direction
	Star3 - direction
	Star4 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet1)
)
(:goal (and
	(pointing satellite0 Star3)
	(have_image Planet1 thermograph0)
	(have_image Planet2 thermograph1)
	(have_image Star3 thermograph1)
	(have_image Star4 thermograph1)
))

)
