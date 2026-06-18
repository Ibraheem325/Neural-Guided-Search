(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	thermograph1 - mode
	spectrograph5 - mode
	spectrograph2 - mode
	infrared4 - mode
	infrared3 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	Star3 - direction
	Planet8 - direction
	Planet9 - direction
	Planet10 - direction
	Star11 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared3)
	(supports instrument0 infrared4)
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph5)
	(supports instrument0 image0)
	(calibration_target instrument0 Star3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star11)
)
(:goal (and
	(have_image Planet8 infrared3)
	(have_image Planet9 infrared4)
	(have_image Planet9 spectrograph5)
	(have_image Planet10 spectrograph5)
	(have_image Star11 image0)
	(have_image Star11 infrared4)
))

)
