(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared0 - mode
	image1 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star9 - direction
	Star3 - direction
	GroundStation2 - direction
	Star6 - direction
	Star10 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 Star3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
)
(:goal (and
	(have_image Star10 infrared0)
))

)
