(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph1 - mode
	infrared0 - mode
	GroundStation0 - direction
	GroundStation2 - direction
	GroundStation1 - direction
	Star3 - direction
	Phenomenon4 - direction
	Planet5 - direction
	Phenomenon6 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
)
(:goal (and
	(pointing satellite0 Phenomenon6)
	(have_image Star3 infrared0)
	(have_image Phenomenon4 infrared0)
	(have_image Planet5 infrared0)
	(have_image Phenomenon6 thermograph1)
))

)
