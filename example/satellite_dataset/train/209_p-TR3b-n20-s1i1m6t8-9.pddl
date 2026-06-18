(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	thermograph4 - mode
	spectrograph1 - mode
	infrared0 - mode
	image5 - mode
	image3 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation4 - direction
	Phenomenon8 - direction
	Planet9 - direction
	Planet10 - direction
	Star11 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 image3)
	(supports instrument0 image5)
	(supports instrument0 infrared0)
	(supports instrument0 thermograph4)
	(supports instrument0 infrared2)
	(calibration_target instrument0 GroundStation4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon8)
)
(:goal (and
	(have_image Phenomenon8 infrared2)
	(have_image Planet9 image5)
	(have_image Planet10 image5)
	(have_image Planet10 spectrograph1)
	(have_image Star11 infrared0)
))

)
