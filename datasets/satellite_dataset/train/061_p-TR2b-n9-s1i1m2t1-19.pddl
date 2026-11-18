(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	image1 - mode
	Star0 - direction
	Planet1 - direction
	Planet2 - direction
	Phenomenon3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 image1)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon3)
)
(:goal (and
	(have_image Planet1 image1)
	(have_image Planet2 image1)
	(have_image Phenomenon3 image1)
	(have_image Planet4 image1)
))

)
