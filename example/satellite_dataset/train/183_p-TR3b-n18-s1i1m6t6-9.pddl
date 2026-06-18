(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared0 - mode
	thermograph4 - mode
	image5 - mode
	spectrograph1 - mode
	infrared2 - mode
	image3 - mode
	GroundStation0 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	Planet6 - direction
	Phenomenon7 - direction
	Planet8 - direction
	Planet9 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 thermograph4)
	(supports instrument0 image5)
	(supports instrument0 image3)
	(supports instrument0 infrared2)
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet6)
)
(:goal (and
	(have_image Planet6 image5)
	(have_image Phenomenon7 thermograph4)
	(have_image Phenomenon7 infrared0)
	(have_image Planet8 image3)
	(have_image Planet9 thermograph4)
	(have_image Planet9 image3)
))

)
