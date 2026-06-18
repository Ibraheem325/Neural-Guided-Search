(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph4 - mode
	infrared2 - mode
	infrared0 - mode
	image3 - mode
	spectrograph1 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation5 - direction
	Star4 - direction
	Star8 - direction
	Planet9 - direction
	Star10 - direction
	Star11 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph1)
	(supports instrument0 image3)
	(supports instrument0 infrared0)
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 GroundStation5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star3)
)
(:goal (and
	(have_image Star8 infrared0)
	(have_image Planet9 infrared0)
	(have_image Star10 spectrograph1)
	(have_image Star11 infrared0)
))

)
