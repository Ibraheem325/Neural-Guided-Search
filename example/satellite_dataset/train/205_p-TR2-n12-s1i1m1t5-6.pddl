(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared0 - mode
	GroundStation0 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Star4 - direction
	Star1 - direction
	Star5 - direction
	Phenomenon6 - direction
	Planet7 - direction
	Planet8 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet8)
)
(:goal (and
	(pointing satellite0 GroundStation2)
	(have_image Star5 infrared0)
	(have_image Phenomenon6 infrared0)
	(have_image Planet7 infrared0)
	(have_image Planet8 infrared0)
))

)
