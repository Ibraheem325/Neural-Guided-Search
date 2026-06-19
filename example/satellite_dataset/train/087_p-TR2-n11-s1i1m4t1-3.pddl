(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image2 - mode
	image3 - mode
	infrared1 - mode
	spectrograph0 - mode
	Star0 - direction
	Planet1 - direction
	Star2 - direction
	Planet3 - direction
	Star4 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared1)
	(supports instrument0 image3)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet3)
)
(:goal (and
	(pointing satellite0 Star2)
	(have_image Planet1 spectrograph0)
	(have_image Star2 infrared1)
	(have_image Planet3 image2)
	(have_image Star4 image2)
))

)
