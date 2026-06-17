(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	infrared0 - mode
	image3 - mode
	spectrograph1 - mode
	GroundStation1 - direction
	GroundStation0 - direction
	Star2 - direction
	Star3 - direction
	Planet4 - direction
	Star5 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 image3)
	(supports instrument0 infrared2)
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
)
(:goal (and
	(have_image Star2 image3)
	(have_image Star3 infrared2)
	(have_image Planet4 infrared0)
	(have_image Star5 infrared2)
))

)
