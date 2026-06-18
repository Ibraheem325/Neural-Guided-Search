(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	instrument4 - instrument
	satellite2 - satellite
	instrument5 - instrument
	instrument6 - instrument
	instrument7 - instrument
	thermograph2 - mode
	infrared0 - mode
	thermograph5 - mode
	thermograph1 - mode
	infrared4 - mode
	image3 - mode
	GroundStation8 - direction
	GroundStation11 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	GroundStation7 - direction
	Star12 - direction
	GroundStation0 - direction
	GroundStation9 - direction
	Star2 - direction
	GroundStation5 - direction
	Star10 - direction
	GroundStation4 - direction
	Star6 - direction
	Planet13 - direction
	Star14 - direction
	Planet15 - direction
	Star16 - direction
)
(:init
	(supports instrument0 infrared4)
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 GroundStation11)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
	(supports instrument1 thermograph1)
	(supports instrument1 thermograph5)
	(supports instrument1 image3)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 Star12)
	(calibration_target instrument1 Star10)
	(calibration_target instrument1 GroundStation3)
	(supports instrument2 infrared0)
	(supports instrument2 image3)
	(supports instrument2 infrared4)
	(calibration_target instrument2 GroundStation9)
	(supports instrument3 thermograph1)
	(calibration_target instrument3 GroundStation4)
	(calibration_target instrument3 Star12)
	(supports instrument4 image3)
	(supports instrument4 infrared4)
	(supports instrument4 infrared0)
	(calibration_target instrument4 GroundStation0)
	(calibration_target instrument4 GroundStation5)
	(calibration_target instrument4 GroundStation4)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star6)
	(supports instrument5 thermograph1)
	(supports instrument5 image3)
	(calibration_target instrument5 GroundStation5)
	(calibration_target instrument5 GroundStation9)
	(calibration_target instrument5 GroundStation0)
	(supports instrument6 thermograph1)
	(calibration_target instrument6 Star2)
	(supports instrument7 infrared4)
	(supports instrument7 thermograph2)
	(supports instrument7 image3)
	(calibration_target instrument7 Star6)
	(calibration_target instrument7 GroundStation4)
	(calibration_target instrument7 Star10)
	(calibration_target instrument7 GroundStation5)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation5)
)
(:goal (and
	(pointing satellite2 GroundStation4)
	(have_image Planet13 thermograph5)
	(have_image Planet13 infrared0)
	(have_image Star14 thermograph1)
	(have_image Star14 infrared4)
	(have_image Planet15 infrared0)
	(have_image Planet15 infrared4)
	(have_image Star16 infrared4)
))

)
