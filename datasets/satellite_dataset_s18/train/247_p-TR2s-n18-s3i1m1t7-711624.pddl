(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	spectrograph0 - mode
	Star1 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	Star0 - direction
	GroundStation3 - direction
	Star5 - direction
	Star2 - direction
	Star7 - direction
	Planet8 - direction
	Planet9 - direction
	Planet10 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 Star5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet8)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 GroundStation3)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet9)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 Star2)
	(calibration_target instrument2 Star5)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star7)
)
(:goal (and
	(pointing satellite2 Star5)
	(have_image Star7 spectrograph0)
	(have_image Planet8 spectrograph0)
	(have_image Planet9 spectrograph0)
	(have_image Planet10 spectrograph0)
))

)
