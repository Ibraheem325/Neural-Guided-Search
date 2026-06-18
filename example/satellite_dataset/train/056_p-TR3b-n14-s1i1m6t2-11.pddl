(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	spectrograph1 - mode
	spectrograph3 - mode
	thermograph4 - mode
	image2 - mode
	image5 - mode
	Star1 - direction
	Star0 - direction
	Phenomenon2 - direction
	Star3 - direction
	Phenomenon4 - direction
	Star5 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 image2)
	(supports instrument0 image5)
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph3)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(have_image Phenomenon2 image5)
	(have_image Phenomenon2 spectrograph1)
	(have_image Star3 spectrograph3)
	(have_image Phenomenon4 image2)
	(have_image Phenomenon4 thermograph0)
	(have_image Star5 image5)
))

)
