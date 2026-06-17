(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph2 - mode
	spectrograph1 - mode
	spectrograph0 - mode
	GroundStation1 - direction
	Star0 - direction
	Star2 - direction
	Star3 - direction
	Phenomenon4 - direction
	Star5 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph0)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon4)
)
(:goal (and
	(have_image Star2 spectrograph2)
	(have_image Star3 spectrograph0)
	(have_image Phenomenon4 spectrograph1)
	(have_image Star5 spectrograph2)
))

)
