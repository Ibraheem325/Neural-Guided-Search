(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	thermograph0 - mode
	thermograph4 - mode
	spectrograph3 - mode
	image2 - mode
	Star0 - direction
	Planet1 - direction
	Star2 - direction
	Planet3 - direction
	Star4 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 spectrograph3)
	(supports instrument0 thermograph4)
	(supports instrument0 thermograph0)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
)
(:goal (and
	(have_image Planet1 thermograph0)
	(have_image Star2 spectrograph1)
	(have_image Planet3 spectrograph1)
	(have_image Star4 spectrograph1)
))

)
