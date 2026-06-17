(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared0 - mode
	thermograph1 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	Star3 - direction
	Star5 - direction
	Star6 - direction
	Star8 - direction
	GroundStation7 - direction
	GroundStation4 - direction
	Planet9 - direction
	Phenomenon10 - direction
	Phenomenon11 - direction
	Star12 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 GroundStation7)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation2)
)
(:goal (and
	(have_image Planet9 infrared0)
	(have_image Phenomenon10 infrared0)
	(have_image Phenomenon11 infrared0)
	(have_image Star12 infrared0)
))

)
