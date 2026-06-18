(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image1 - mode
	spectrograph0 - mode
	thermograph2 - mode
	Star0 - direction
	Star2 - direction
	Star3 - direction
	Star5 - direction
	Star4 - direction
	Star1 - direction
	Star6 - direction
	Planet7 - direction
	Planet8 - direction
	Planet9 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 spectrograph0)
	(supports instrument0 image1)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
)
(:goal (and
	(have_image Star6 spectrograph0)
	(have_image Planet7 image1)
	(have_image Planet8 thermograph2)
	(have_image Planet9 spectrograph0)
))

)
