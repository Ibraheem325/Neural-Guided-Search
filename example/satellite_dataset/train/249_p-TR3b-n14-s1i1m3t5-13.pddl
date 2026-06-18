(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	image1 - mode
	thermograph2 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	Star4 - direction
	Star3 - direction
	Star5 - direction
	Phenomenon6 - direction
	Planet7 - direction
	Star8 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 spectrograph0)
	(supports instrument0 image1)
	(calibration_target instrument0 Star3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
)
(:goal (and
	(have_image Star5 spectrograph0)
	(have_image Phenomenon6 image1)
	(have_image Planet7 image1)
	(have_image Star8 image1)
))

)
