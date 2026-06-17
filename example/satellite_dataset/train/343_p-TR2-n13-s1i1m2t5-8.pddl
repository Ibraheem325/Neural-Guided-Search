(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph1 - mode
	image0 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	GroundStation2 - direction
	Phenomenon5 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
)
(:goal (and
	(have_image Phenomenon5 thermograph1)
	(have_image Star6 thermograph1)
	(have_image Star7 image0)
	(have_image Star8 thermograph1)
))

)
