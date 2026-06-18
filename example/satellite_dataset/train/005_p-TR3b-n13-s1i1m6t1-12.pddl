(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	thermograph3 - mode
	spectrograph4 - mode
	image1 - mode
	infrared5 - mode
	infrared2 - mode
	Star0 - direction
	Phenomenon1 - direction
	Phenomenon2 - direction
	Star3 - direction
	Phenomenon4 - direction
)
(:init
	(supports instrument0 thermograph3)
	(supports instrument0 thermograph0)
	(supports instrument0 infrared2)
	(supports instrument0 infrared5)
	(supports instrument0 image1)
	(supports instrument0 spectrograph4)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(pointing satellite0 Phenomenon1)
	(have_image Phenomenon1 infrared2)
	(have_image Phenomenon2 image1)
	(have_image Phenomenon2 thermograph0)
	(have_image Star3 infrared5)
	(have_image Star3 infrared2)
	(have_image Phenomenon4 image1)
))

)
