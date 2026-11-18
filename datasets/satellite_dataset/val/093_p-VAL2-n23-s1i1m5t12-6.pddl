(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph1 - mode
	thermograph2 - mode
	infrared4 - mode
	image3 - mode
	infrared0 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	Star6 - direction
	Star7 - direction
	GroundStation8 - direction
	Star9 - direction
	Star10 - direction
	GroundStation11 - direction
	Star5 - direction
	GroundStation4 - direction
	Star12 - direction
	Star13 - direction
	Star14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 thermograph2)
	(supports instrument0 thermograph1)
	(supports instrument0 image3)
	(supports instrument0 infrared4)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 Star5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon15)
)
(:goal (and
	(pointing satellite0 GroundStation2)
	(have_image Star12 infrared0)
	(have_image Star13 thermograph2)
	(have_image Star14 infrared0)
	(have_image Phenomenon15 thermograph2)
))

)
