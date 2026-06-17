(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	infrared0 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	Star3 - direction
	Planet4 - direction
	Star5 - direction
	Phenomenon6 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon6)
)
(:goal (and
	(have_image Star3 spectrograph1)
	(have_image Planet4 spectrograph1)
	(have_image Star5 spectrograph1)
	(have_image Phenomenon6 infrared0)
))

)
