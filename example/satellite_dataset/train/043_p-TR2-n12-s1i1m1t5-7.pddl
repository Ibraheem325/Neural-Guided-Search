(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	GroundStation0 - direction
	Star1 - direction
	Star3 - direction
	Star4 - direction
	Star2 - direction
	Star5 - direction
	Phenomenon6 - direction
	Phenomenon7 - direction
	Star8 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
)
(:goal (and
	(have_image Star5 image0)
	(have_image Phenomenon6 image0)
	(have_image Phenomenon7 image0)
	(have_image Star8 image0)
))

)
