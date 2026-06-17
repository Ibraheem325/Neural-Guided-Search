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
	GroundStation4 - direction
	Star6 - direction
	Star8 - direction
	GroundStation9 - direction
	Star10 - direction
	GroundStation11 - direction
	Star12 - direction
	GroundStation7 - direction
	Star5 - direction
	Star3 - direction
	Phenomenon13 - direction
	Planet14 - direction
	Planet15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 GroundStation7)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star12)
)
(:goal (and
	(have_image Phenomenon13 thermograph1)
	(have_image Planet14 infrared0)
	(have_image Planet15 infrared0)
	(have_image Phenomenon16 thermograph1)
))

)
