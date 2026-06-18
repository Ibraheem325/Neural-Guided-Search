(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	instrument4 - instrument
	satellite2 - satellite
	instrument5 - instrument
	thermograph5 - mode
	image3 - mode
	infrared4 - mode
	thermograph2 - mode
	infrared0 - mode
	thermograph1 - mode
	Star2 - direction
	GroundStation3 - direction
	GroundStation9 - direction
	GroundStation4 - direction
	GroundStation0 - direction
	GroundStation11 - direction
	GroundStation1 - direction
	Star10 - direction
	GroundStation7 - direction
	GroundStation5 - direction
	Star6 - direction
	GroundStation8 - direction
	Star12 - direction
	Star13 - direction
	Planet14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 thermograph5)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 GroundStation11)
	(calibration_target instrument0 GroundStation8)
	(supports instrument1 thermograph5)
	(supports instrument1 thermograph1)
	(calibration_target instrument1 GroundStation5)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 Star10)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet14)
	(supports instrument2 infrared4)
	(supports instrument2 image3)
	(supports instrument2 infrared0)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 GroundStation0)
	(calibration_target instrument2 GroundStation4)
	(supports instrument3 infrared4)
	(calibration_target instrument3 GroundStation1)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 GroundStation11)
	(supports instrument4 image3)
	(supports instrument4 infrared4)
	(calibration_target instrument4 GroundStation7)
	(calibration_target instrument4 Star10)
	(calibration_target instrument4 GroundStation8)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star6)
	(supports instrument5 thermograph1)
	(supports instrument5 thermograph2)
	(calibration_target instrument5 GroundStation8)
	(calibration_target instrument5 Star6)
	(calibration_target instrument5 GroundStation5)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation4)
)
(:goal (and
	(have_image Star12 infrared0)
	(have_image Star13 thermograph2)
	(have_image Star13 infrared4)
	(have_image Planet14 thermograph2)
	(have_image Planet14 infrared0)
	(have_image Phenomenon15 infrared0)
))

)
