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
	satellite4 - satellite
	instrument7 - instrument
	instrument8 - instrument
	instrument9 - instrument
	satellite5 - satellite
	instrument10 - instrument
	satellite6 - satellite
	instrument11 - instrument
	instrument12 - instrument
	instrument13 - instrument
	satellite7 - satellite
	instrument14 - instrument
	image0 - mode
	thermograph1 - mode
	infrared3 - mode
	image2 - mode
	GroundStation3 - direction
	Star0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	Phenomenon4 - direction
	Star5 - direction
	Planet6 - direction
	Star7 - direction
	Star8 - direction
	Phenomenon9 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared3)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 image0)
	(supports instrument1 infrared3)
	(calibration_target instrument1 GroundStation2)
	(supports instrument2 thermograph1)
	(calibration_target instrument2 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon9)
	(supports instrument3 infrared3)
	(calibration_target instrument3 GroundStation1)
	(supports instrument4 image2)
	(calibration_target instrument4 Star0)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star5)
	(supports instrument5 infrared3)
	(supports instrument5 thermograph1)
	(calibration_target instrument5 Star0)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon4)
	(supports instrument6 image2)
	(supports instrument6 infrared3)
	(calibration_target instrument6 Star0)
	(on_board instrument6 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star0)
	(supports instrument7 infrared3)
	(supports instrument7 image0)
	(supports instrument7 thermograph1)
	(calibration_target instrument7 GroundStation1)
	(supports instrument8 image0)
	(calibration_target instrument8 GroundStation1)
	(supports instrument9 infrared3)
	(supports instrument9 thermograph1)
	(supports instrument9 image0)
	(calibration_target instrument9 GroundStation1)
	(on_board instrument7 satellite4)
	(on_board instrument8 satellite4)
	(on_board instrument9 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star0)
	(supports instrument10 thermograph1)
	(supports instrument10 image2)
	(calibration_target instrument10 GroundStation2)
	(on_board instrument10 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Star8)
	(supports instrument11 infrared3)
	(supports instrument11 thermograph1)
	(supports instrument11 image0)
	(calibration_target instrument11 Star0)
	(supports instrument12 image0)
	(supports instrument12 infrared3)
	(supports instrument12 thermograph1)
	(calibration_target instrument12 GroundStation2)
	(supports instrument13 infrared3)
	(calibration_target instrument13 GroundStation1)
	(on_board instrument11 satellite6)
	(on_board instrument12 satellite6)
	(on_board instrument13 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Star7)
	(supports instrument14 image0)
	(supports instrument14 thermograph1)
	(calibration_target instrument14 GroundStation2)
	(on_board instrument14 satellite7)
	(power_avail satellite7)
	(pointing satellite7 GroundStation2)
)
(:goal (and
	(pointing satellite0 Star5)
	(pointing satellite2 Star8)
	(pointing satellite4 Star0)
	(pointing satellite6 Star7)
	(have_image Phenomenon4 image0)
	(have_image Star5 infrared3)
	(have_image Planet6 image2)
	(have_image Star7 thermograph1)
	(have_image Star8 image0)
	(have_image Phenomenon9 image2)
))

)
