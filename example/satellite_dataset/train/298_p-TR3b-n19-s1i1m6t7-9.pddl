(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image5 - mode
	thermograph4 - mode
	spectrograph1 - mode
	infrared2 - mode
	image3 - mode
	infrared0 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	Star5 - direction
	Phenomenon7 - direction
	Phenomenon8 - direction
	Star9 - direction
	Phenomenon10 - direction
)
(:init
	(supports instrument0 image5)
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared0)
	(supports instrument0 image3)
	(supports instrument0 thermograph4)
	(calibration_target instrument0 Star5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon8)
)
(:goal (and
	(have_image Phenomenon7 thermograph4)
	(have_image Phenomenon7 infrared0)
	(have_image Phenomenon8 spectrograph1)
	(have_image Star9 infrared0)
	(have_image Star9 infrared2)
	(have_image Phenomenon10 infrared2)
))

)
