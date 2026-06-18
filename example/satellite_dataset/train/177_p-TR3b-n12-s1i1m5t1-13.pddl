(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	thermograph2 - mode
	spectrograph4 - mode
	image1 - mode
	infrared3 - mode
	Star0 - direction
	Planet1 - direction
	Phenomenon2 - direction
	Star3 - direction
	Star4 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph0)
	(supports instrument0 image1)
	(supports instrument0 spectrograph4)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
)
(:goal (and
	(pointing satellite0 Planet1)
	(have_image Planet1 spectrograph0)
	(have_image Phenomenon2 image1)
	(have_image Star3 thermograph2)
	(have_image Star4 spectrograph0)
))

)
