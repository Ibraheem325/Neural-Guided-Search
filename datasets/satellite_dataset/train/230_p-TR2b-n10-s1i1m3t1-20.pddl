(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph2 - mode
	infrared0 - mode
	spectrograph1 - mode
	Star0 - direction
	Planet1 - direction
	Star2 - direction
	Star3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared0)
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet1)
)
(:goal (and
	(pointing satellite0 Star2)
	(have_image Planet1 spectrograph1)
	(have_image Star2 infrared0)
	(have_image Star3 spectrograph2)
	(have_image Planet4 infrared0)
))

)
