(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	thermograph1 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	Phenomenon2 - direction
	Star3 - direction
	Planet4 - direction
	Phenomenon5 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet4)
)
(:goal (and
	(pointing satellite0 GroundStation1)
	(have_image Phenomenon2 thermograph1)
	(have_image Star3 thermograph1)
	(have_image Planet4 image0)
	(have_image Phenomenon5 thermograph1)
))

)
