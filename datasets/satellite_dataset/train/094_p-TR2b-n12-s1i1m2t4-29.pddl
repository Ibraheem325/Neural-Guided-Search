(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	image1 - mode
	GroundStation0 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Star1 - direction
	Phenomenon4 - direction
	Planet5 - direction
	Phenomenon6 - direction
	Star7 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
)
(:goal (and
	(have_image Phenomenon4 image1)
	(have_image Planet5 thermograph0)
	(have_image Phenomenon6 image1)
	(have_image Star7 image1)
))

)
