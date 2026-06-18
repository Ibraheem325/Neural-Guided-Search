(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph2 - mode
	image3 - mode
	infrared0 - mode
	thermograph1 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	Star8 - direction
	Star9 - direction
	Star11 - direction
	Star12 - direction
	GroundStation13 - direction
	GroundStation10 - direction
	Star7 - direction
	Planet14 - direction
	Planet15 - direction
	Phenomenon16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 image3)
	(supports instrument0 thermograph2)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation10)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon16)
)
(:goal (and
	(have_image Planet14 image3)
	(have_image Planet15 thermograph2)
	(have_image Phenomenon16 infrared0)
	(have_image Phenomenon17 infrared0)
))

)
