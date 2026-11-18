(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image3 - mode
	infrared0 - mode
	thermograph2 - mode
	infrared4 - mode
	thermograph1 - mode
	thermograph5 - mode
	GroundStation0 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	Star6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	Star10 - direction
	Star12 - direction
	GroundStation11 - direction
	GroundStation1 - direction
	Planet13 - direction
	Star14 - direction
	Planet15 - direction
	Star16 - direction
)
(:init
	(supports instrument0 infrared4)
	(supports instrument0 infrared0)
	(supports instrument0 thermograph5)
	(supports instrument0 thermograph1)
	(supports instrument0 thermograph2)
	(supports instrument0 image3)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 GroundStation11)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
)
(:goal (and
	(have_image Planet13 thermograph5)
	(have_image Planet13 infrared0)
	(have_image Star14 thermograph1)
	(have_image Star14 infrared4)
	(have_image Planet15 infrared0)
	(have_image Planet15 infrared4)
	(have_image Star16 infrared4)
))

)
