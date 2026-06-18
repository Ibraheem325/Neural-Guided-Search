(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	thermograph4 - mode
	image3 - mode
	infrared0 - mode
	image5 - mode
	spectrograph1 - mode
	GroundStation0 - direction
	Planet1 - direction
	Star2 - direction
	Star3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 image5)
	(supports instrument0 infrared0)
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph1)
	(supports instrument0 image3)
	(supports instrument0 thermograph4)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet1)
)
(:goal (and
	(have_image Planet1 image5)
	(have_image Star2 image5)
	(have_image Star3 spectrograph1)
	(have_image Planet4 spectrograph1)
))

)
