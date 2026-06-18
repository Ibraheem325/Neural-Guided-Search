(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph5 - mode
	image0 - mode
	spectrograph2 - mode
	infrared3 - mode
	infrared4 - mode
	thermograph1 - mode
	Star1 - direction
	GroundStation0 - direction
	Planet2 - direction
	Star3 - direction
	Planet4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 infrared3)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared4)
	(supports instrument0 image0)
	(supports instrument0 spectrograph5)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
)
(:goal (and
	(have_image Planet2 thermograph1)
	(have_image Star3 infrared4)
	(have_image Planet4 spectrograph5)
	(have_image Planet4 infrared3)
	(have_image Planet5 spectrograph2)
	(have_image Planet5 spectrograph5)
))

)
