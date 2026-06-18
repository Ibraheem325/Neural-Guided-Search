(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph2 - mode
	spectrograph0 - mode
	image1 - mode
	Star0 - direction
	Star1 - direction
	Star3 - direction
	Star4 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	Star2 - direction
	Star8 - direction
	Planet9 - direction
	Star10 - direction
	Star11 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 thermograph2)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet9)
)
(:goal (and
	(pointing satellite0 Star6)
	(have_image Star8 image1)
	(have_image Planet9 spectrograph0)
	(have_image Star10 image1)
	(have_image Star11 spectrograph0)
))

)
