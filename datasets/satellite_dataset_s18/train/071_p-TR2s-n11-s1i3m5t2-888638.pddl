(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	image4 - mode
	spectrograph3 - mode
	image1 - mode
	image2 - mode
	Star0 - direction
	GroundStation1 - direction
	Phenomenon2 - direction
	Star3 - direction
)
(:init
	(supports instrument0 image4)
	(supports instrument0 image1)
	(supports instrument0 image2)
	(supports instrument0 spectrograph3)
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon2)
)
(:goal (and
	(have_image Phenomenon2 image1)
	(have_image Star3 image0)
))

)
