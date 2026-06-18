(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	infrared0 - mode
	image3 - mode
	spectrograph1 - mode
	infrared2 - mode
	thermograph4 - mode
	image5 - mode
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	GroundStation7 - direction
	Star9 - direction
	GroundStation11 - direction
	GroundStation8 - direction
	GroundStation0 - direction
	GroundStation3 - direction
	Star5 - direction
	GroundStation10 - direction
	GroundStation6 - direction
	Star12 - direction
	Star13 - direction
	Planet14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 image3)
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 GroundStation8)
	(supports instrument1 image5)
	(supports instrument1 spectrograph1)
	(supports instrument1 image3)
	(calibration_target instrument1 GroundStation3)
	(supports instrument2 infrared2)
	(supports instrument2 image5)
	(supports instrument2 image3)
	(supports instrument2 thermograph4)
	(calibration_target instrument2 GroundStation6)
	(calibration_target instrument2 GroundStation10)
	(calibration_target instrument2 Star5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation8)
)
(:goal (and
	(have_image Star12 infrared0)
	(have_image Star13 infrared2)
	(have_image Star13 infrared0)
	(have_image Planet14 image3)
	(have_image Planet15 spectrograph1)
))

)
