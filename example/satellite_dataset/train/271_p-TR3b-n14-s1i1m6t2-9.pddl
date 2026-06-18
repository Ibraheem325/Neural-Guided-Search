(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	image5 - mode
	infrared0 - mode
	image3 - mode
	infrared2 - mode
	thermograph4 - mode
	GroundStation1 - direction
	GroundStation0 - direction
	Planet2 - direction
	Star3 - direction
	Phenomenon4 - direction
	Star5 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared2)
	(supports instrument0 thermograph4)
	(supports instrument0 image3)
	(supports instrument0 infrared0)
	(supports instrument0 image5)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star3)
)
(:goal (and
	(pointing satellite0 Star5)
	(have_image Planet2 infrared0)
	(have_image Star3 infrared0)
	(have_image Star3 image5)
	(have_image Phenomenon4 thermograph4)
	(have_image Star5 thermograph4)
	(have_image Star5 image3)
))

)
