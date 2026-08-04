(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	instrument5 - instrument
	satellite3 - satellite
	instrument6 - instrument
	instrument7 - instrument
	satellite4 - satellite
	instrument8 - instrument
	instrument9 - instrument
	instrument10 - instrument
	satellite5 - satellite
	instrument11 - instrument
	thermograph1 - mode
	infrared0 - mode
	GroundStation6 - direction
	Star11 - direction
	GroundStation13 - direction
	Star15 - direction
	GroundStation9 - direction
	GroundStation8 - direction
	GroundStation1 - direction
	Star10 - direction
	Star16 - direction
	GroundStation0 - direction
	Star3 - direction
	GroundStation5 - direction
	GroundStation12 - direction
	Star2 - direction
	GroundStation7 - direction
	Star14 - direction
	Star4 - direction
	Planet17 - direction
	Planet18 - direction
	Phenomenon19 - direction
	Planet20 - direction
	Planet21 - direction
	Phenomenon22 - direction
	Planet23 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation13)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 infrared0)
	(supports instrument1 thermograph1)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 Star14)
	(supports instrument2 infrared0)
	(calibration_target instrument2 GroundStation0)
	(calibration_target instrument2 GroundStation12)
	(calibration_target instrument2 Star14)
	(calibration_target instrument2 GroundStation5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star16)
	(supports instrument3 infrared0)
	(calibration_target instrument3 GroundStation13)
	(calibration_target instrument3 GroundStation5)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation1)
	(supports instrument4 infrared0)
	(supports instrument4 thermograph1)
	(calibration_target instrument4 GroundStation12)
	(calibration_target instrument4 Star15)
	(supports instrument5 infrared0)
	(calibration_target instrument5 GroundStation8)
	(calibration_target instrument5 Star14)
	(calibration_target instrument5 Star3)
	(calibration_target instrument5 GroundStation9)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet17)
	(supports instrument6 infrared0)
	(calibration_target instrument6 Star10)
	(calibration_target instrument6 Star2)
	(calibration_target instrument6 GroundStation1)
	(supports instrument7 thermograph1)
	(supports instrument7 infrared0)
	(calibration_target instrument7 GroundStation0)
	(calibration_target instrument7 Star16)
	(calibration_target instrument7 GroundStation5)
	(on_board instrument6 satellite3)
	(on_board instrument7 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation7)
	(supports instrument8 thermograph1)
	(supports instrument8 infrared0)
	(calibration_target instrument8 GroundStation12)
	(calibration_target instrument8 Star4)
	(calibration_target instrument8 Star14)
	(calibration_target instrument8 GroundStation5)
	(calibration_target instrument8 Star3)
	(supports instrument9 infrared0)
	(supports instrument9 thermograph1)
	(calibration_target instrument9 Star2)
	(supports instrument10 thermograph1)
	(calibration_target instrument10 Star14)
	(calibration_target instrument10 GroundStation7)
	(calibration_target instrument10 Star2)
	(on_board instrument8 satellite4)
	(on_board instrument9 satellite4)
	(on_board instrument10 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Planet20)
	(supports instrument11 infrared0)
	(supports instrument11 thermograph1)
	(calibration_target instrument11 Star4)
	(on_board instrument11 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Planet18)
)
(:goal (and
	(have_image Planet17 infrared0)
	(have_image Planet18 infrared0)
	(have_image Phenomenon19 infrared0)
	(have_image Planet20 thermograph1)
	(have_image Planet21 infrared0)
	(have_image Phenomenon22 thermograph1)
	(have_image Planet23 infrared0)
))

)
