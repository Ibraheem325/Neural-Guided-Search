(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph2 - mode
	image1 - mode
	thermograph0 - mode
	thermograph3 - mode
	GroundStation0 - direction
	Planet1 - direction
	Star2 - direction
	Planet3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 thermograph3)
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet4)
)
(:goal (and
	(pointing satellite0 Planet1)
	(have_image Planet1 thermograph2)
	(have_image Star2 thermograph0)
	(have_image Planet3 thermograph3)
	(have_image Planet4 image1)
))

)
