(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	Star3 - direction
	Star2 - direction
	Star4 - direction
	Star5 - direction
	Star6 - direction
	Phenomenon7 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
)
(:goal (and
	(have_image Star4 spectrograph0)
	(have_image Star5 spectrograph0)
	(have_image Star6 spectrograph0)
	(have_image Phenomenon7 spectrograph0)
))

)
