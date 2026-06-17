(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	thermograph1 - mode
	spectrograph2 - mode
	Star0 - direction
	Planet1 - direction
	Star2 - direction
	Star3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 spectrograph2)
	(supports instrument0 image0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star3)
)
(:goal (and
	(have_image Planet1 thermograph1)
	(have_image Star2 thermograph1)
	(have_image Star3 image0)
	(have_image Planet4 spectrograph2)
))

)
