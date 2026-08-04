(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph3 - mode
	image2 - mode
	spectrograph1 - mode
	infrared0 - mode
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation0 - direction
	Star4 - direction
	Phenomenon7 - direction
	Star8 - direction
	Planet9 - direction
	Star10 - direction
	Star11 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared0)
	(supports instrument0 image2)
	(supports instrument0 thermograph3)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation6)
)
(:goal (and
	(pointing satellite0 Phenomenon7)
	(have_image Phenomenon7 thermograph3)
	(have_image Star8 infrared0)
	(have_image Planet9 thermograph3)
	(have_image Star10 spectrograph1)
	(have_image Star11 spectrograph1)
))

)
