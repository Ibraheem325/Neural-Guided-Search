(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	image4 - mode
	image2 - mode
	spectrograph1 - mode
	thermograph3 - mode
	infrared0 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	Star8 - direction
	Star10 - direction
	Star12 - direction
	GroundStation15 - direction
	GroundStation16 - direction
	Star17 - direction
	Star18 - direction
	Star19 - direction
	Star22 - direction
	GroundStation23 - direction
	Star24 - direction
	Star25 - direction
	GroundStation26 - direction
	GroundStation27 - direction
	GroundStation28 - direction
	GroundStation29 - direction
	Star11 - direction
	GroundStation20 - direction
	GroundStation2 - direction
	GroundStation14 - direction
	Star21 - direction
	Star9 - direction
	GroundStation4 - direction
	Star13 - direction
	Star30 - direction
	Phenomenon31 - direction
	Planet32 - direction
)
(:init
	(supports instrument0 thermograph3)
	(supports instrument0 image2)
	(calibration_target instrument0 Star11)
	(supports instrument1 image4)
	(supports instrument1 infrared0)
	(supports instrument1 image2)
	(supports instrument1 spectrograph1)
	(calibration_target instrument1 Star13)
	(calibration_target instrument1 GroundStation4)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 Star21)
	(calibration_target instrument1 GroundStation14)
	(calibration_target instrument1 GroundStation2)
	(calibration_target instrument1 GroundStation20)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation27)
)
(:goal (and
	(have_image Star30 image4)
	(have_image Phenomenon31 thermograph3)
	(have_image Planet32 image2)
))

)
