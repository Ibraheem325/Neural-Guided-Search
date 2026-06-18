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
	instrument8 - instrument
	instrument9 - instrument
	satellite4 - satellite
	instrument10 - instrument
	instrument11 - instrument
	instrument12 - instrument
	instrument13 - instrument
	image6 - mode
	infrared1 - mode
	thermograph2 - mode
	image0 - mode
	infrared4 - mode
	infrared5 - mode
	infrared3 - mode
	Star8 - direction
	Star6 - direction
	Star1 - direction
	Star3 - direction
	Star5 - direction
	Star7 - direction
	Star9 - direction
	Star0 - direction
	Star2 - direction
	GroundStation4 - direction
	Star10 - direction
	Star11 - direction
	Phenomenon12 - direction
	Phenomenon13 - direction
)
(:init
	(supports instrument0 infrared5)
	(supports instrument0 infrared3)
	(supports instrument0 image6)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 Star9)
	(supports instrument1 infrared3)
	(supports instrument1 image0)
	(supports instrument1 thermograph2)
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 Star7)
	(calibration_target instrument1 GroundStation4)
	(supports instrument2 image0)
	(calibration_target instrument2 Star8)
	(calibration_target instrument2 Star5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
	(supports instrument3 infrared1)
	(supports instrument3 infrared4)
	(calibration_target instrument3 Star0)
	(calibration_target instrument3 Star1)
	(calibration_target instrument3 Star8)
	(supports instrument4 infrared1)
	(supports instrument4 infrared4)
	(supports instrument4 image6)
	(calibration_target instrument4 Star2)
	(calibration_target instrument4 Star5)
	(calibration_target instrument4 Star9)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon12)
	(supports instrument5 infrared5)
	(calibration_target instrument5 Star1)
	(calibration_target instrument5 Star6)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon12)
	(supports instrument6 infrared1)
	(calibration_target instrument6 GroundStation4)
	(calibration_target instrument6 Star2)
	(calibration_target instrument6 Star0)
	(supports instrument7 image0)
	(supports instrument7 infrared3)
	(supports instrument7 image6)
	(calibration_target instrument7 Star5)
	(calibration_target instrument7 Star1)
	(calibration_target instrument7 Star3)
	(supports instrument8 image0)
	(supports instrument8 infrared3)
	(supports instrument8 infrared5)
	(calibration_target instrument8 Star3)
	(supports instrument9 thermograph2)
	(calibration_target instrument9 Star5)
	(calibration_target instrument9 Star9)
	(on_board instrument6 satellite3)
	(on_board instrument7 satellite3)
	(on_board instrument8 satellite3)
	(on_board instrument9 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star6)
	(supports instrument10 thermograph2)
	(calibration_target instrument10 Star7)
	(supports instrument11 infrared1)
	(supports instrument11 image0)
	(supports instrument11 image6)
	(calibration_target instrument11 Star9)
	(calibration_target instrument11 Star0)
	(supports instrument12 infrared5)
	(supports instrument12 infrared4)
	(calibration_target instrument12 Star2)
	(calibration_target instrument12 Star0)
	(supports instrument13 infrared3)
	(calibration_target instrument13 GroundStation4)
	(on_board instrument10 satellite4)
	(on_board instrument11 satellite4)
	(on_board instrument12 satellite4)
	(on_board instrument13 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star8)
)
(:goal (and
	(pointing satellite2 Star0)
	(pointing satellite3 Star1)
	(have_image Star10 infrared5)
	(have_image Star10 thermograph2)
	(have_image Star11 infrared1)
	(have_image Star11 image0)
	(have_image Phenomenon12 infrared4)
	(have_image Phenomenon12 infrared5)
	(have_image Phenomenon13 thermograph2)
))

)
