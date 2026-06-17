(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	infrared0 - mode
	Star1 - direction
	Star2 - direction
	Star3 - direction
	Star4 - direction
	Star0 - direction
	Star5 - direction
	Planet6 - direction
	Star7 - direction
	Star8 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star3)
)
(:goal (and
	(have_image Star5 infrared0)
	(have_image Planet6 infrared0)
	(have_image Star7 spectrograph1)
	(have_image Star8 infrared0)
))

)
