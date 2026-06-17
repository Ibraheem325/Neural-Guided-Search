(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared0 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Star5 - direction
	Star4 - direction
	Planet6 - direction
	Star7 - direction
	Phenomenon8 - direction
	Planet9 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
)
(:goal (and
	(have_image Planet6 infrared0)
	(have_image Star7 infrared0)
	(have_image Phenomenon8 infrared0)
	(have_image Planet9 infrared0)
))

)
