(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph1 - mode
	infrared0 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	Star3 - direction
	Star5 - direction
	GroundStation7 - direction
	Star8 - direction
	GroundStation9 - direction
	Star10 - direction
	Star6 - direction
	GroundStation4 - direction
	Planet11 - direction
	Star12 - direction
	Planet13 - direction
	Star14 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 Star6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
)
(:goal (and
	(have_image Planet11 infrared0)
	(have_image Star12 thermograph1)
	(have_image Planet13 infrared0)
	(have_image Star14 infrared0)
))

)
