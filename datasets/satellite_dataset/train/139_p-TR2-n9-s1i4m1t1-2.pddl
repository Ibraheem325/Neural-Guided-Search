(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	spectrograph0 - mode
	GroundStation0 - direction
	Phenomenon1 - direction
	Star2 - direction
	Planet3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 GroundStation0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet3)
)
(:goal (and
	(pointing satellite0 Star2)
	(have_image Phenomenon1 spectrograph0)
	(have_image Star2 spectrograph0)
	(have_image Planet3 spectrograph0)
	(have_image Planet4 spectrograph0)
))

)
