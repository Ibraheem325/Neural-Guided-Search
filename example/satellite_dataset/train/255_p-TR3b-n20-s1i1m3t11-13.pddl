(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image1 - mode
	thermograph2 - mode
	spectrograph0 - mode
	Star0 - direction
	Star1 - direction
	Star3 - direction
	Star4 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	Star9 - direction
	Star10 - direction
	Star2 - direction
	Star8 - direction
	Planet11 - direction
	Star12 - direction
	Star13 - direction
	Phenomenon14 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 image1)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star12)
)
(:goal (and
	(have_image Planet11 image1)
	(have_image Star12 spectrograph0)
	(have_image Star13 spectrograph0)
	(have_image Phenomenon14 image1)
))

)
