(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	GroundStation0 - direction
	Star2 - direction
	GroundStation1 - direction
	Star3 - direction
	Star4 - direction
	Phenomenon5 - direction
	Planet6 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet6)
)
(:goal (and
	(have_image Star3 spectrograph0)
	(have_image Star4 spectrograph0)
	(have_image Phenomenon5 spectrograph0)
	(have_image Planet6 spectrograph0)
))

)
