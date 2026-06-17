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
	infrared0 - mode
	thermograph2 - mode
	thermograph1 - mode
	Star0 - direction
	GroundStation7 - direction
	Star8 - direction
	Star5 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation1 - direction
	GroundStation9 - direction
	Star6 - direction
	Star4 - direction
	GroundStation10 - direction
	Phenomenon11 - direction
	Star12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 GroundStation3)
	(supports instrument1 infrared0)
	(supports instrument1 thermograph2)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 Star4)
	(supports instrument2 infrared0)
	(calibration_target instrument2 GroundStation9)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon14)
	(supports instrument3 infrared0)
	(supports instrument3 thermograph1)
	(calibration_target instrument3 Star8)
	(supports instrument4 infrared0)
	(supports instrument4 thermograph1)
	(supports instrument4 thermograph2)
	(calibration_target instrument4 GroundStation1)
	(supports instrument5 thermograph1)
	(supports instrument5 infrared0)
	(supports instrument5 thermograph2)
	(calibration_target instrument5 GroundStation3)
	(calibration_target instrument5 Star6)
	(supports instrument6 thermograph2)
	(supports instrument6 infrared0)
	(supports instrument6 thermograph1)
	(calibration_target instrument6 GroundStation2)
	(calibration_target instrument6 GroundStation3)
	(calibration_target instrument6 Star5)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon11)
	(supports instrument7 infrared0)
	(supports instrument7 thermograph1)
	(supports instrument7 thermograph2)
	(calibration_target instrument7 GroundStation2)
	(calibration_target instrument7 Star6)
	(on_board instrument7 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star5)
	(supports instrument8 thermograph1)
	(supports instrument8 thermograph2)
	(supports instrument8 infrared0)
	(calibration_target instrument8 GroundStation2)
	(calibration_target instrument8 GroundStation9)
	(supports instrument9 thermograph1)
	(calibration_target instrument9 GroundStation3)
	(calibration_target instrument9 GroundStation2)
	(supports instrument10 thermograph1)
	(supports instrument10 infrared0)
	(calibration_target instrument10 GroundStation9)
	(calibration_target instrument10 Star4)
	(calibration_target instrument10 GroundStation1)
	(supports instrument11 thermograph2)
	(supports instrument11 thermograph1)
	(supports instrument11 infrared0)
	(calibration_target instrument11 Star6)
	(supports instrument12 thermograph1)
	(calibration_target instrument12 GroundStation10)
	(calibration_target instrument12 Star4)
	(on_board instrument8 satellite3)
	(on_board instrument9 satellite3)
	(on_board instrument10 satellite3)
	(on_board instrument11 satellite3)
	(on_board instrument12 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star0)
)
(:goal (and
	(pointing satellite3 Star5)
	(have_image Phenomenon11 thermograph1)
	(have_image Star12 infrared0)
	(have_image Phenomenon13 infrared0)
	(have_image Phenomenon14 thermograph2)
))

)
