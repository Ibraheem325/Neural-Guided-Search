(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph2 - mode
	infrared6 - mode
	spectrograph0 - mode
	image1 - mode
	image5 - mode
	infrared3 - mode
	spectrograph4 - mode
	GroundStation0 - direction
	Star1 - direction
	Star3 - direction
	Star4 - direction
	Star5 - direction
	GroundStation8 - direction
	GroundStation2 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	Star9 - direction
	Planet10 - direction
	Planet11 - direction
	Star12 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph4)
	(supports instrument0 image5)
	(supports instrument0 image1)
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared6)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 GroundStation2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation8)
)
(:goal (and
	(pointing satellite0 GroundStation8)
	(have_image Star9 infrared3)
	(have_image Star9 spectrograph0)
	(have_image Planet10 infrared3)
	(have_image Planet10 spectrograph0)
	(have_image Planet11 spectrograph0)
	(have_image Star12 image1)
	(have_image Star12 thermograph2)
))

)
