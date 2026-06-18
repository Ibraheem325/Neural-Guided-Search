(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	spectrograph4 - mode
	image1 - mode
	infrared2 - mode
	thermograph3 - mode
	Star0 - direction
	Phenomenon1 - direction
	Planet2 - direction
	Phenomenon3 - direction
	Star4 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph3)
	(supports instrument0 infrared2)
	(supports instrument0 image1)
	(supports instrument0 spectrograph4)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon3)
)
(:goal (and
	(have_image Phenomenon1 thermograph0)
	(have_image Planet2 infrared2)
	(have_image Phenomenon3 image1)
	(have_image Star4 thermograph0)
))

)
