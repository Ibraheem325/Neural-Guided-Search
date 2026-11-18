(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image2 - mode
	infrared1 - mode
	spectrograph0 - mode
	spectrograph3 - mode
	Star0 - direction
	Phenomenon1 - direction
	Star2 - direction
	Phenomenon3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 spectrograph3)
	(supports instrument0 spectrograph0)
	(supports instrument0 image2)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet4)
)
(:goal (and
	(pointing satellite0 Star2)
	(have_image Phenomenon1 spectrograph0)
	(have_image Star2 spectrograph0)
	(have_image Phenomenon3 infrared1)
	(have_image Planet4 spectrograph3)
))

)
