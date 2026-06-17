(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	spectrograph1 - mode
	GroundStation0 - direction
	Star1 - direction
	Star2 - direction
	Planet3 - direction
	Star4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
)
(:goal (and
	(have_image Star2 spectrograph1)
	(have_image Planet3 spectrograph0)
	(have_image Star4 spectrograph1)
	(have_image Planet5 spectrograph1)
))

)
