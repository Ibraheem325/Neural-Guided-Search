(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph2 - mode
	thermograph0 - mode
	image1 - mode
	GroundStation0 - direction
	Star1 - direction
	Star3 - direction
	GroundStation2 - direction
	Star4 - direction
	Planet5 - direction
	Planet6 - direction
	Star7 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 image1)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet5)
)
(:goal (and
	(have_image Star4 thermograph0)
	(have_image Planet5 thermograph2)
	(have_image Planet6 thermograph2)
	(have_image Star7 thermograph2)
))

)
