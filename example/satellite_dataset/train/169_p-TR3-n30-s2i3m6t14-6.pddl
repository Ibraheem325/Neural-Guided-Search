(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	thermograph1 - mode
	thermograph2 - mode
	image3 - mode
	infrared4 - mode
	infrared0 - mode
	thermograph5 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation11 - direction
	Star12 - direction
	GroundStation5 - direction
	Star2 - direction
	GroundStation9 - direction
	GroundStation13 - direction
	Star10 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Planet16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 image3)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared0)
	(supports instrument0 infrared4)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation7)
	(supports instrument1 image3)
	(supports instrument1 thermograph5)
	(supports instrument1 thermograph1)
	(calibration_target instrument1 Star10)
	(calibration_target instrument1 GroundStation13)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 Star2)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation5)
)
(:goal (and
	(have_image Planet14 infrared0)
	(have_image Planet14 image3)
	(have_image Phenomenon15 image3)
	(have_image Planet16 image3)
	(have_image Phenomenon17 infrared0)
))

)
