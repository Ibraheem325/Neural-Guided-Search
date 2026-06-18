(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	instrument4 - instrument
	satellite1 - satellite
	instrument5 - instrument
	instrument6 - instrument
	instrument7 - instrument
	satellite2 - satellite
	instrument8 - instrument
	instrument9 - instrument
	instrument10 - instrument
	instrument11 - instrument
	instrument12 - instrument
	satellite3 - satellite
	instrument13 - instrument
	satellite4 - satellite
	instrument14 - instrument
	infrared3 - mode
	infrared1 - mode
	thermograph2 - mode
	infrared4 - mode
	image0 - mode
	Star2 - direction
	GroundStation4 - direction
	Star0 - direction
	Star10 - direction
	Star1 - direction
	Star3 - direction
	Star8 - direction
	GroundStation5 - direction
	Star9 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	Planet11 - direction
	Planet12 - direction
	Phenomenon13 - direction
	Planet14 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 infrared4)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 Star3)
	(supports instrument1 image0)
	(supports instrument1 infrared3)
	(supports instrument1 infrared4)
	(calibration_target instrument1 Star10)
	(calibration_target instrument1 Star8)
	(calibration_target instrument1 GroundStation5)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 Star1)
	(calibration_target instrument2 GroundStation7)
	(calibration_target instrument2 Star10)
	(supports instrument3 thermograph2)
	(supports instrument3 image0)
	(supports instrument3 infrared1)
	(calibration_target instrument3 Star2)
	(calibration_target instrument3 GroundStation5)
	(calibration_target instrument3 GroundStation6)
	(supports instrument4 infrared1)
	(supports instrument4 image0)
	(supports instrument4 infrared3)
	(calibration_target instrument4 Star3)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(on_board instrument4 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet12)
	(supports instrument5 infrared1)
	(calibration_target instrument5 Star3)
	(calibration_target instrument5 Star8)
	(supports instrument6 image0)
	(calibration_target instrument6 Star0)
	(calibration_target instrument6 Star2)
	(calibration_target instrument6 GroundStation7)
	(supports instrument7 thermograph2)
	(supports instrument7 infrared4)
	(supports instrument7 infrared1)
	(calibration_target instrument7 GroundStation6)
	(calibration_target instrument7 Star8)
	(calibration_target instrument7 GroundStation4)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(on_board instrument7 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star9)
	(supports instrument8 infrared3)
	(calibration_target instrument8 GroundStation4)
	(calibration_target instrument8 GroundStation5)
	(supports instrument9 image0)
	(supports instrument9 infrared1)
	(calibration_target instrument9 Star8)
	(calibration_target instrument9 GroundStation6)
	(calibration_target instrument9 Star0)
	(supports instrument10 thermograph2)
	(calibration_target instrument10 Star10)
	(calibration_target instrument10 GroundStation6)
	(calibration_target instrument10 GroundStation7)
	(supports instrument11 infrared3)
	(supports instrument11 infrared1)
	(calibration_target instrument11 Star1)
	(supports instrument12 infrared1)
	(calibration_target instrument12 Star8)
	(calibration_target instrument12 Star3)
	(on_board instrument8 satellite2)
	(on_board instrument9 satellite2)
	(on_board instrument10 satellite2)
	(on_board instrument11 satellite2)
	(on_board instrument12 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet14)
	(supports instrument13 infrared3)
	(supports instrument13 infrared4)
	(supports instrument13 image0)
	(calibration_target instrument13 GroundStation5)
	(calibration_target instrument13 Star8)
	(on_board instrument13 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star2)
	(supports instrument14 infrared3)
	(calibration_target instrument14 GroundStation7)
	(calibration_target instrument14 GroundStation6)
	(calibration_target instrument14 Star9)
	(on_board instrument14 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Planet11)
)
(:goal (and
	(pointing satellite0 Planet14)
	(pointing satellite1 GroundStation7)
	(pointing satellite2 Planet12)
	(have_image Planet11 infrared3)
	(have_image Planet12 image0)
	(have_image Phenomenon13 image0)
	(have_image Planet14 infrared1)
))

)
