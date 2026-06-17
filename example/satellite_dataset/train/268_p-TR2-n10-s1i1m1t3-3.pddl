(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	Star1 - direction
	Star2 - direction
	Star0 - direction
	Star3 - direction
	Star4 - direction
	Phenomenon5 - direction
	Star6 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(have_image Star3 spectrograph0)
	(have_image Star4 spectrograph0)
	(have_image Phenomenon5 spectrograph0)
	(have_image Star6 spectrograph0)
))

)
