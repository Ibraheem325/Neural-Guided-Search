(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image3 - mode
	image2 - mode
	infrared1 - mode
	thermograph0 - mode
	Star0 - direction
	Phenomenon1 - direction
	Phenomenon2 - direction
	Star3 - direction
	Star4 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 image2)
	(supports instrument0 image3)
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon2)
)
(:goal (and
	(have_image Phenomenon1 image2)
	(have_image Phenomenon2 infrared1)
	(have_image Star3 thermograph0)
	(have_image Star4 infrared1)
))

)
