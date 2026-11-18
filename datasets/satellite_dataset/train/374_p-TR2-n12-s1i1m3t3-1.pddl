(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph2 - mode
	image1 - mode
	thermograph0 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	Phenomenon4 - direction
	Star5 - direction
	Phenomenon6 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 image1)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon6)
)
(:goal (and
	(pointing satellite0 Star5)
	(have_image Star3 thermograph0)
	(have_image Phenomenon4 thermograph2)
	(have_image Star5 thermograph0)
	(have_image Phenomenon6 thermograph2)
))

)
