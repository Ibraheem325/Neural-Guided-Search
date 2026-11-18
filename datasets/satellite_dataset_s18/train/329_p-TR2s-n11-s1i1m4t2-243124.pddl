(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image2 - mode
	infrared0 - mode
	infrared1 - mode
	thermograph3 - mode
	Star1 - direction
	Star0 - direction
	Star2 - direction
	Star3 - direction
	Star4 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 thermograph3)
	(supports instrument0 infrared1)
	(supports instrument0 image2)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(have_image Star2 infrared1)
	(have_image Star3 image2)
	(have_image Star4 image2)
))

)
