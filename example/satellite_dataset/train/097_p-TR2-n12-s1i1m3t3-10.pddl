(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	spectrograph0 - mode
	spectrograph2 - mode
	Star0 - direction
	GroundStation1 - direction
	Star2 - direction
	Planet3 - direction
	Star4 - direction
	Star5 - direction
	Planet6 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
)
(:goal (and
	(have_image Planet3 spectrograph1)
	(have_image Star4 spectrograph0)
	(have_image Star5 spectrograph2)
	(have_image Planet6 spectrograph0)
))

)
