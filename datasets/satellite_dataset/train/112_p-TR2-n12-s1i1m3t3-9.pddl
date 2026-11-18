(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	infrared0 - mode
	spectrograph1 - mode
	GroundStation1 - direction
	GroundStation2 - direction
	Star0 - direction
	Planet3 - direction
	Planet4 - direction
	Phenomenon5 - direction
	Star6 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(pointing satellite0 Planet4)
	(have_image Planet3 infrared0)
	(have_image Planet4 spectrograph1)
	(have_image Phenomenon5 infrared0)
	(have_image Star6 infrared0)
))

)
