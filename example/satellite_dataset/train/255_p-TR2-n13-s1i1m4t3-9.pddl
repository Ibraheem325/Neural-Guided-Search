(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image3 - mode
	infrared2 - mode
	spectrograph1 - mode
	infrared0 - mode
	GroundStation1 - direction
	Star2 - direction
	GroundStation0 - direction
	Planet3 - direction
	Star4 - direction
	Phenomenon5 - direction
	Planet6 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared0)
	(supports instrument0 infrared2)
	(supports instrument0 image3)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet6)
)
(:goal (and
	(have_image Planet3 infrared2)
	(have_image Star4 image3)
	(have_image Phenomenon5 infrared2)
	(have_image Planet6 infrared0)
))

)
