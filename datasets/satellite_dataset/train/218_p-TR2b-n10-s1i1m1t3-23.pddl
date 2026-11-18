(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	Star0 - direction
	GroundStation2 - direction
	Star1 - direction
	Star3 - direction
	Star4 - direction
	Planet5 - direction
	Phenomenon6 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet5)
)
(:goal (and
	(pointing satellite0 Star3)
	(have_image Star3 spectrograph0)
	(have_image Star4 spectrograph0)
	(have_image Planet5 spectrograph0)
	(have_image Phenomenon6 spectrograph0)
))

)
