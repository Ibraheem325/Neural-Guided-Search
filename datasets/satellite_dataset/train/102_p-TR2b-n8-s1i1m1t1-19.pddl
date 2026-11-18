(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	Star0 - direction
	Star1 - direction
	Phenomenon2 - direction
	Planet3 - direction
	Phenomenon4 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon2)
)
(:goal (and
	(pointing satellite0 Planet3)
	(have_image Star1 image0)
	(have_image Phenomenon2 image0)
	(have_image Planet3 image0)
	(have_image Phenomenon4 image0)
))

)
