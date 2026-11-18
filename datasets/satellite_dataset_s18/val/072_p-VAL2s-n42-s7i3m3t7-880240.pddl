(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	instrument4 - instrument
	satellite2 - satellite
	instrument5 - instrument
	satellite3 - satellite
	instrument6 - instrument
	instrument7 - instrument
	satellite4 - satellite
	instrument8 - instrument
	satellite5 - satellite
	instrument9 - instrument
	instrument10 - instrument
	instrument11 - instrument
	satellite6 - satellite
	instrument12 - instrument
	instrument13 - instrument
	thermograph2 - mode
	infrared0 - mode
	infrared1 - mode
	GroundStation3 - direction
	Star4 - direction
	Star5 - direction
	GroundStation2 - direction
	Star1 - direction
	Star6 - direction
	GroundStation0 - direction
	Star7 - direction
	Planet8 - direction
	Star9 - direction
	Star10 - direction
	Planet11 - direction
	Star12 - direction
	Planet13 - direction
	Planet14 - direction
	Planet15 - direction
	Star16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 infrared1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star6)
	(supports instrument1 thermograph2)
	(supports instrument1 infrared1)
	(supports instrument1 infrared0)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 GroundStation2)
	(supports instrument2 infrared0)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 Star1)
	(calibration_target instrument2 GroundStation3)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet11)
	(supports instrument3 infrared0)
	(supports instrument3 infrared1)
	(supports instrument3 thermograph2)
	(calibration_target instrument3 Star1)
	(supports instrument4 infrared0)
	(supports instrument4 thermograph2)
	(supports instrument4 infrared1)
	(calibration_target instrument4 Star5)
	(calibration_target instrument4 Star4)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet15)
	(supports instrument5 thermograph2)
	(supports instrument5 infrared0)
	(supports instrument5 infrared1)
	(calibration_target instrument5 Star5)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet15)
	(supports instrument6 thermograph2)
	(calibration_target instrument6 Star6)
	(calibration_target instrument6 Star5)
	(supports instrument7 thermograph2)
	(calibration_target instrument7 Star6)
	(on_board instrument6 satellite3)
	(on_board instrument7 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet15)
	(supports instrument8 infrared0)
	(supports instrument8 infrared1)
	(calibration_target instrument8 Star1)
	(calibration_target instrument8 Star6)
	(on_board instrument8 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Planet14)
	(supports instrument9 thermograph2)
	(supports instrument9 infrared0)
	(calibration_target instrument9 GroundStation2)
	(supports instrument10 infrared1)
	(supports instrument10 thermograph2)
	(calibration_target instrument10 GroundStation2)
	(calibration_target instrument10 GroundStation0)
	(supports instrument11 thermograph2)
	(calibration_target instrument11 Star1)
	(on_board instrument9 satellite5)
	(on_board instrument10 satellite5)
	(on_board instrument11 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Star9)
	(supports instrument12 infrared1)
	(supports instrument12 thermograph2)
	(supports instrument12 infrared0)
	(calibration_target instrument12 Star6)
	(supports instrument13 thermograph2)
	(calibration_target instrument13 GroundStation0)
	(on_board instrument12 satellite6)
	(on_board instrument13 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Star7)
)
(:goal (and
	(pointing satellite0 Star5)
	(pointing satellite1 Planet13)
	(pointing satellite5 GroundStation2)
	(have_image Star7 infrared0)
	(have_image Planet8 thermograph2)
	(have_image Star9 infrared1)
	(have_image Star10 infrared1)
	(have_image Planet11 infrared0)
	(have_image Star12 thermograph2)
	(have_image Planet13 infrared1)
	(have_image Planet14 infrared0)
	(have_image Planet15 infrared0)
	(have_image Star16 infrared1)
	(have_image Planet17 infrared1)
))

)
