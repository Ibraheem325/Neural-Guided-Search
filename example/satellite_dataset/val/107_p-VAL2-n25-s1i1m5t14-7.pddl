(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared4 - mode
	infrared3 - mode
	spectrograph2 - mode
	thermograph1 - mode
	image0 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	Star4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	Star7 - direction
	GroundStation8 - direction
	GroundStation11 - direction
	Star12 - direction
	Star13 - direction
	Star3 - direction
	GroundStation10 - direction
	GroundStation9 - direction
	GroundStation2 - direction
	Star14 - direction
	Star15 - direction
	Star16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 image0)
	(supports instrument0 spectrograph2)
	(supports instrument0 infrared3)
	(supports instrument0 infrared4)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 Star3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet17)
)
(:goal (and
	(pointing satellite0 GroundStation10)
	(have_image Star14 infrared4)
	(have_image Star15 thermograph1)
	(have_image Star16 image0)
	(have_image Planet17 thermograph1)
))

)
