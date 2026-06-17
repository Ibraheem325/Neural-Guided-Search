(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	Star0 - direction
	Planet1 - direction
	Phenomenon2 - direction
	Star3 - direction
	Phenomenon4 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon4)
)
(:goal (and
	(have_image Planet1 thermograph0)
	(have_image Phenomenon2 thermograph0)
	(have_image Star3 thermograph0)
	(have_image Phenomenon4 thermograph0)
))

)
