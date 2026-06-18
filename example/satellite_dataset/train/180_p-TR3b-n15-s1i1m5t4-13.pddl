(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph4 - mode
	spectrograph0 - mode
	infrared3 - mode
	thermograph2 - mode
	image1 - mode
	Star0 - direction
	GroundStation1 - direction
	Star2 - direction
	Star3 - direction
	Phenomenon4 - direction
	Star5 - direction
	Planet6 - direction
	Star7 - direction
)
(:init
	(supports instrument0 spectrograph4)
	(supports instrument0 image1)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon4)
)
(:goal (and
	(pointing satellite0 Star3)
	(have_image Phenomenon4 spectrograph0)
	(have_image Star5 infrared3)
	(have_image Planet6 thermograph2)
	(have_image Star7 thermograph2)
))

)
