(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared1 - mode
	infrared2 - mode
	thermograph0 - mode
	Star0 - direction
	Phenomenon1 - direction
	Planet2 - direction
	Star3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 infrared2)
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet4)
)
(:goal (and
	(have_image Phenomenon1 thermograph0)
	(have_image Planet2 thermograph0)
	(have_image Star3 thermograph0)
	(have_image Planet4 thermograph0)
))

)
