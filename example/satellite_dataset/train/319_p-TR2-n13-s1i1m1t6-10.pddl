(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	Star4 - direction
	Star5 - direction
	Star2 - direction
	Star3 - direction
	Planet6 - direction
	Planet7 - direction
	Phenomenon8 - direction
	Star9 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star3)
)
(:goal (and
	(have_image Planet6 spectrograph0)
	(have_image Planet7 spectrograph0)
	(have_image Phenomenon8 spectrograph0)
	(have_image Star9 spectrograph0)
))

)
