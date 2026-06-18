(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared0 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation3 - direction
	Star5 - direction
	GroundStation6 - direction
	Star7 - direction
	Star4 - direction
	GroundStation2 - direction
	Star8 - direction
	Phenomenon9 - direction
	Planet10 - direction
	Phenomenon11 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet10)
)
(:goal (and
	(have_image Star8 infrared0)
	(have_image Phenomenon9 infrared0)
	(have_image Planet10 infrared0)
	(have_image Phenomenon11 infrared0)
))

)
