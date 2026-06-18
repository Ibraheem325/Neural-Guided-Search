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
	GroundStation4 - direction
	Star8 - direction
	GroundStation9 - direction
	Star10 - direction
	GroundStation11 - direction
	GroundStation13 - direction
	Star12 - direction
	Star5 - direction
	Star6 - direction
	GroundStation7 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Planet16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 Star12)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet16)
)
(:goal (and
	(have_image Planet14 thermograph1)
	(have_image Phenomenon15 infrared0)
	(have_image Planet16 thermograph1)
	(have_image Phenomenon17 thermograph1)
))

)
