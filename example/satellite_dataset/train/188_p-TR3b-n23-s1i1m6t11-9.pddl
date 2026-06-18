(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared0 - mode
	infrared2 - mode
	image5 - mode
	thermograph4 - mode
	spectrograph1 - mode
	image3 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation6 - direction
	Star9 - direction
	GroundStation10 - direction
	GroundStation3 - direction
	GroundStation8 - direction
	GroundStation7 - direction
	Planet11 - direction
	Planet12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 image3)
	(supports instrument0 thermograph4)
	(supports instrument0 image5)
	(supports instrument0 infrared2)
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 GroundStation3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation7)
)
(:goal (and
	(have_image Planet11 thermograph4)
	(have_image Planet12 infrared0)
	(have_image Planet12 image3)
	(have_image Phenomenon13 image5)
	(have_image Phenomenon13 image3)
	(have_image Phenomenon14 image5)
	(have_image Phenomenon14 image3)
))

)
