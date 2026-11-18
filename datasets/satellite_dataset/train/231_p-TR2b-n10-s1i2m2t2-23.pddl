(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	image1 - mode
	spectrograph0 - mode
	GroundStation1 - direction
	GroundStation0 - direction
	Planet2 - direction
	Planet3 - direction
	Star4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 spectrograph0)
	(supports instrument1 image1)
	(calibration_target instrument1 GroundStation0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
)
(:goal (and
	(have_image Planet2 image1)
	(have_image Planet3 image1)
	(have_image Star4 spectrograph0)
	(have_image Planet5 spectrograph0)
))

)
