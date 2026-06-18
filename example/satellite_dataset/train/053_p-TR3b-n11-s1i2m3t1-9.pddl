(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	infrared2 - mode
	spectrograph1 - mode
	infrared0 - mode
	Star0 - direction
	Planet1 - direction
	Star2 - direction
	Planet3 - direction
	Star4 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star0)
	(supports instrument1 spectrograph1)
	(supports instrument1 infrared2)
	(supports instrument1 infrared0)
	(calibration_target instrument1 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet3)
)
(:goal (and
	(pointing satellite0 Planet3)
	(have_image Planet1 infrared2)
	(have_image Star2 infrared2)
	(have_image Planet3 infrared2)
	(have_image Star4 spectrograph1)
))

)
