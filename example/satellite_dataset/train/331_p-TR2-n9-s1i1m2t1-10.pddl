(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	spectrograph0 - mode
	GroundStation0 - direction
	Star1 - direction
	Planet2 - direction
	Star3 - direction
	Phenomenon4 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet2)
)
(:goal (and
	(have_image Star1 spectrograph0)
	(have_image Planet2 spectrograph1)
	(have_image Star3 spectrograph1)
	(have_image Phenomenon4 spectrograph1)
))

)
