(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph4 - mode
	image2 - mode
	spectrograph1 - mode
	infrared0 - mode
	image3 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	Star3 - direction
	Planet4 - direction
	Planet5 - direction
	Phenomenon6 - direction
	Star7 - direction
	Planet8 - direction
	Planet9 - direction
	Phenomenon10 - direction
	Star11 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 image3)
	(supports instrument0 infrared0)
	(supports instrument0 spectrograph1)
	(supports instrument0 image2)
	(calibration_target instrument0 Star3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet4)
)
(:goal (and
	(pointing satellite0 Star11)
	(have_image Planet4 spectrograph1)
	(have_image Planet5 thermograph4)
	(have_image Phenomenon6 spectrograph1)
	(have_image Star7 thermograph4)
	(have_image Planet8 infrared0)
	(have_image Planet9 image3)
	(have_image Phenomenon10 image2)
	(have_image Star11 image3)
))

)
