(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	image0 - mode
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation0 - direction
	GroundStation1 - direction
	Star4 - direction
	Planet5 - direction
	Phenomenon6 - direction
	Star7 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation1)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet5)
)
(:goal (and
	(have_image Star4 image0)
	(have_image Planet5 image0)
	(have_image Phenomenon6 image0)
	(have_image Star7 image0)
))

)
