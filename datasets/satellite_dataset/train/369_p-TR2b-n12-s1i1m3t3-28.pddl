(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image2 - mode
	infrared1 - mode
	spectrograph0 - mode
	Star0 - direction
	Star2 - direction
	Star1 - direction
	Planet3 - direction
	Star4 - direction
	Phenomenon5 - direction
	Star6 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared1)
	(supports instrument0 image2)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet3)
)
(:goal (and
	(have_image Planet3 image2)
	(have_image Star4 image2)
	(have_image Phenomenon5 spectrograph0)
	(have_image Star6 spectrograph0)
))

)
