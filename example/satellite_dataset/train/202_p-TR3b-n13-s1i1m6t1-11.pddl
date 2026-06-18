(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image2 - mode
	spectrograph3 - mode
	thermograph4 - mode
	spectrograph1 - mode
	thermograph0 - mode
	image5 - mode
	Star0 - direction
	Phenomenon1 - direction
	Star2 - direction
	Star3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 thermograph0)
	(supports instrument0 spectrograph3)
	(supports instrument0 image5)
	(supports instrument0 thermograph4)
	(supports instrument0 image2)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon1)
)
(:goal (and
	(pointing satellite0 Phenomenon1)
	(have_image Phenomenon1 spectrograph1)
	(have_image Star2 spectrograph3)
	(have_image Star3 spectrograph1)
	(have_image Planet4 thermograph0)
))

)
