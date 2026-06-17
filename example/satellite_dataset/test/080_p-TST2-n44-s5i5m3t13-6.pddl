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
	instrument5 - instrument
	instrument6 - instrument
	satellite2 - satellite
	instrument7 - instrument
	satellite3 - satellite
	instrument8 - instrument
	instrument9 - instrument
	instrument10 - instrument
	instrument11 - instrument
	instrument12 - instrument
	satellite4 - satellite
	instrument13 - instrument
	instrument14 - instrument
	infrared0 - mode
	thermograph2 - mode
	thermograph1 - mode
	GroundStation2 - direction
	Star8 - direction
	Star0 - direction
	GroundStation3 - direction
	GroundStation9 - direction
	Star11 - direction
	GroundStation1 - direction
	GroundStation7 - direction
	Star5 - direction
	GroundStation12 - direction
	GroundStation10 - direction
	Star4 - direction
	Star6 - direction
	Phenomenon13 - direction
	Star14 - direction
	Phenomenon15 - direction
	Star16 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation9)
	(supports instrument1 thermograph2)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 GroundStation10)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star11)
	(supports instrument2 thermograph1)
	(supports instrument2 infrared0)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 GroundStation9)
	(calibration_target instrument2 Star5)
	(calibration_target instrument2 Star4)
	(supports instrument3 thermograph1)
	(supports instrument3 infrared0)
	(calibration_target instrument3 Star8)
	(calibration_target instrument3 GroundStation7)
	(calibration_target instrument3 Star5)
	(supports instrument4 infrared0)
	(calibration_target instrument4 GroundStation12)
	(supports instrument5 thermograph2)
	(supports instrument5 infrared0)
	(supports instrument5 thermograph1)
	(calibration_target instrument5 GroundStation10)
	(supports instrument6 infrared0)
	(calibration_target instrument6 GroundStation2)
	(calibration_target instrument6 Star8)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation1)
	(supports instrument7 infrared0)
	(supports instrument7 thermograph2)
	(supports instrument7 thermograph1)
	(calibration_target instrument7 Star8)
	(calibration_target instrument7 Star6)
	(calibration_target instrument7 GroundStation12)
	(on_board instrument7 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon15)
	(supports instrument8 thermograph1)
	(calibration_target instrument8 Star0)
	(supports instrument9 thermograph2)
	(calibration_target instrument9 GroundStation12)
	(calibration_target instrument9 GroundStation10)
	(supports instrument10 infrared0)
	(supports instrument10 thermograph2)
	(supports instrument10 thermograph1)
	(calibration_target instrument10 Star4)
	(calibration_target instrument10 GroundStation9)
	(calibration_target instrument10 GroundStation3)
	(calibration_target instrument10 GroundStation1)
	(supports instrument11 thermograph2)
	(supports instrument11 infrared0)
	(calibration_target instrument11 Star11)
	(supports instrument12 thermograph1)
	(supports instrument12 thermograph2)
	(calibration_target instrument12 Star5)
	(calibration_target instrument12 GroundStation7)
	(calibration_target instrument12 GroundStation1)
	(on_board instrument8 satellite3)
	(on_board instrument9 satellite3)
	(on_board instrument10 satellite3)
	(on_board instrument11 satellite3)
	(on_board instrument12 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation9)
	(supports instrument13 thermograph1)
	(supports instrument13 infrared0)
	(calibration_target instrument13 GroundStation10)
	(calibration_target instrument13 GroundStation12)
	(supports instrument14 thermograph2)
	(supports instrument14 infrared0)
	(supports instrument14 thermograph1)
	(calibration_target instrument14 Star6)
	(calibration_target instrument14 Star4)
	(on_board instrument13 satellite4)
	(on_board instrument14 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation3)
)
(:goal (and
	(pointing satellite0 Star11)
	(pointing satellite1 Star8)
	(pointing satellite4 GroundStation3)
	(have_image Phenomenon13 thermograph2)
	(have_image Star14 thermograph1)
	(have_image Phenomenon15 thermograph2)
	(have_image Star16 thermograph2)
))

)
