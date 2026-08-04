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
	instrument6 - instrument
	instrument7 - instrument
	satellite3 - satellite
	instrument8 - instrument
	instrument9 - instrument
	instrument10 - instrument
	satellite4 - satellite
	instrument11 - instrument
	instrument12 - instrument
	satellite5 - satellite
	instrument13 - instrument
	instrument14 - instrument
	instrument15 - instrument
	satellite6 - satellite
	instrument16 - instrument
	infrared4 - mode
	infrared0 - mode
	thermograph3 - mode
	image1 - mode
	infrared2 - mode
	Star3 - direction
	Star1 - direction
	Star0 - direction
	Star2 - direction
	Star4 - direction
	Planet5 - direction
	Planet6 - direction
	Planet7 - direction
	Star8 - direction
	Phenomenon9 - direction
	Star10 - direction
	Planet11 - direction
)
(:init
	(supports instrument0 thermograph3)
	(calibration_target instrument0 Star0)
	(supports instrument1 infrared0)
	(supports instrument1 image1)
	(calibration_target instrument1 Star1)
	(supports instrument2 infrared4)
	(supports instrument2 thermograph3)
	(supports instrument2 image1)
	(calibration_target instrument2 Star2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet11)
	(supports instrument3 thermograph3)
	(supports instrument3 infrared2)
	(calibration_target instrument3 Star1)
	(supports instrument4 thermograph3)
	(supports instrument4 infrared2)
	(supports instrument4 infrared0)
	(calibration_target instrument4 Star3)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star4)
	(supports instrument5 thermograph3)
	(supports instrument5 image1)
	(calibration_target instrument5 Star3)
	(supports instrument6 infrared4)
	(calibration_target instrument6 Star2)
	(supports instrument7 infrared4)
	(calibration_target instrument7 Star2)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet5)
	(supports instrument8 image1)
	(supports instrument8 infrared0)
	(calibration_target instrument8 Star0)
	(supports instrument9 infrared2)
	(supports instrument9 infrared0)
	(calibration_target instrument9 Star1)
	(supports instrument10 image1)
	(calibration_target instrument10 Star3)
	(on_board instrument8 satellite3)
	(on_board instrument9 satellite3)
	(on_board instrument10 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet11)
	(supports instrument11 infrared0)
	(supports instrument11 image1)
	(calibration_target instrument11 Star1)
	(supports instrument12 infrared0)
	(supports instrument12 thermograph3)
	(calibration_target instrument12 Star1)
	(on_board instrument11 satellite4)
	(on_board instrument12 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Phenomenon9)
	(supports instrument13 thermograph3)
	(supports instrument13 image1)
	(calibration_target instrument13 Star2)
	(supports instrument14 image1)
	(calibration_target instrument14 Star2)
	(supports instrument15 infrared0)
	(supports instrument15 thermograph3)
	(supports instrument15 infrared2)
	(calibration_target instrument15 Star0)
	(on_board instrument13 satellite5)
	(on_board instrument14 satellite5)
	(on_board instrument15 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Planet5)
	(supports instrument16 image1)
	(calibration_target instrument16 Star2)
	(on_board instrument16 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Star3)
)
(:goal (and
	(pointing satellite0 Phenomenon9)
	(pointing satellite3 Star10)
	(pointing satellite5 Star2)
	(pointing satellite6 Star2)
	(have_image Star4 infrared4)
	(have_image Planet5 thermograph3)
	(have_image Planet6 infrared4)
	(have_image Planet7 infrared2)
	(have_image Star8 image1)
	(have_image Phenomenon9 infrared2)
	(have_image Star10 infrared2)
	(have_image Planet11 image1)
))

)
