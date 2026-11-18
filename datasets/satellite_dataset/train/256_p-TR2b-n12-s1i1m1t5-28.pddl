(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	Star0 - direction
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star1 - direction
	Star5 - direction
	Planet6 - direction
	Star7 - direction
	Planet8 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(pointing satellite0 Star1)
	(have_image Star5 spectrograph0)
	(have_image Planet6 spectrograph0)
	(have_image Star7 spectrograph0)
	(have_image Planet8 spectrograph0)
))

)
