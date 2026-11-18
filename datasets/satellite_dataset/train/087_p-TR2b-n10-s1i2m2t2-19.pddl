(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	image0 - mode
	image1 - mode
	Star0 - direction
	GroundStation1 - direction
	Phenomenon2 - direction
	Star3 - direction
	Phenomenon4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 image1)
	(calibration_target instrument0 Star0)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation1)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star3)
)
(:goal (and
	(have_image Phenomenon2 image1)
	(have_image Star3 image0)
	(have_image Phenomenon4 image0)
	(have_image Planet5 image1)
))

)
