(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared0 - mode
	GroundStation0 - direction
	GroundStation2 - direction
	Star3 - direction
	Star4 - direction
	GroundStation1 - direction
	Star5 - direction
	Planet6 - direction
	Star7 - direction
	Star8 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star7)
)
(:goal (and
	(pointing satellite0 GroundStation0)
	(have_image Star5 infrared0)
	(have_image Planet6 infrared0)
	(have_image Star7 infrared0)
	(have_image Star8 infrared0)
))

)
