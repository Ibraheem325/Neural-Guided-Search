(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared0 - mode
	thermograph2 - mode
	thermograph1 - mode
	infrared4 - mode
	image3 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	GroundStation8 - direction
	Star9 - direction
	Star10 - direction
	GroundStation11 - direction
	Star12 - direction
	Star7 - direction
	Planet13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared4)
	(supports instrument0 thermograph2)
	(supports instrument0 image3)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star7)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star9)
)
(:goal (and
	(pointing satellite0 Star3)
	(have_image Planet13 image3)
	(have_image Phenomenon14 thermograph1)
	(have_image Phenomenon15 thermograph1)
	(have_image Phenomenon16 infrared0)
))

)
