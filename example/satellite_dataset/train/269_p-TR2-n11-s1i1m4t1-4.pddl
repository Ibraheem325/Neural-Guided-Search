(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	infrared1 - mode
	image3 - mode
	infrared2 - mode
	Star0 - direction
	Phenomenon1 - direction
	Planet2 - direction
	Star3 - direction
	Star4 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 image3)
	(supports instrument0 infrared2)
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
)
(:goal (and
	(pointing satellite0 Star3)
	(have_image Phenomenon1 infrared1)
	(have_image Planet2 thermograph0)
	(have_image Star3 infrared2)
	(have_image Star4 thermograph0)
))

)
