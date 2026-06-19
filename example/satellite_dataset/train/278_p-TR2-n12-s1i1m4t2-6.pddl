(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image3 - mode
	infrared0 - mode
	thermograph1 - mode
	thermograph2 - mode
	Star1 - direction
	Star0 - direction
	Planet2 - direction
	Star3 - direction
	Star4 - direction
	Star5 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 thermograph2)
	(supports instrument0 thermograph1)
	(supports instrument0 image3)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
)
(:goal (and
	(pointing satellite0 Star3)
	(have_image Planet2 thermograph1)
	(have_image Star3 infrared0)
	(have_image Star4 image3)
	(have_image Star5 thermograph1)
))

)
