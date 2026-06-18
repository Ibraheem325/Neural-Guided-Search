(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	infrared2 - mode
	infrared0 - mode
	image3 - mode
	GroundStation0 - direction
	Phenomenon1 - direction
	Planet2 - direction
	Planet3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 infrared0)
	(supports instrument0 image3)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet4)
)
(:goal (and
	(pointing satellite0 Planet4)
	(have_image Phenomenon1 infrared2)
	(have_image Planet2 infrared0)
	(have_image Planet3 spectrograph1)
	(have_image Planet4 infrared2)
))

)
