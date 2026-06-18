(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared0 - mode
	spectrograph1 - mode
	infrared2 - mode
	Star0 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	Star7 - direction
	Phenomenon8 - direction
	Phenomenon9 - direction
	Planet10 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star7)
)
(:goal (and
	(pointing satellite0 GroundStation6)
	(have_image Star7 infrared2)
	(have_image Phenomenon8 infrared2)
	(have_image Phenomenon9 infrared0)
	(have_image Planet10 infrared0)
))

)
