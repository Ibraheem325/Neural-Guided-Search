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
	instrument8 - instrument
	instrument9 - instrument
	satellite2 - satellite
	instrument10 - instrument
	instrument11 - instrument
	infrared1 - mode
	thermograph2 - mode
	image0 - mode
	infrared5 - mode
	infrared3 - mode
	infrared4 - mode
	Star4 - direction
	Star3 - direction
	GroundStation6 - direction
	Star2 - direction
	GroundStation11 - direction
	GroundStation10 - direction
	GroundStation9 - direction
	GroundStation12 - direction
	GroundStation5 - direction
	Star7 - direction
	GroundStation1 - direction
	Star0 - direction
	Star8 - direction
	Star13 - direction
	Phenomenon14 - direction
	Planet15 - direction
	Star16 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 infrared3)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 GroundStation6)
	(supports instrument1 infrared5)
	(supports instrument1 image0)
	(supports instrument1 infrared3)
	(calibration_target instrument1 Star2)
	(calibration_target instrument1 Star0)
	(calibration_target instrument1 GroundStation6)
	(calibration_target instrument1 Star8)
	(supports instrument2 infrared4)
	(calibration_target instrument2 Star8)
	(calibration_target instrument2 GroundStation6)
	(calibration_target instrument2 GroundStation5)
	(calibration_target instrument2 Star3)
	(supports instrument3 thermograph2)
	(supports instrument3 infrared4)
	(supports instrument3 infrared3)
	(calibration_target instrument3 GroundStation5)
	(calibration_target instrument3 GroundStation10)
	(calibration_target instrument3 GroundStation1)
	(supports instrument4 infrared3)
	(calibration_target instrument4 GroundStation1)
	(calibration_target instrument4 GroundStation12)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(on_board instrument4 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation9)
	(supports instrument5 infrared1)
	(supports instrument5 infrared3)
	(supports instrument5 thermograph2)
	(calibration_target instrument5 GroundStation9)
	(supports instrument6 infrared1)
	(calibration_target instrument6 GroundStation12)
	(calibration_target instrument6 GroundStation5)
	(calibration_target instrument6 Star7)
	(calibration_target instrument6 Star2)
	(supports instrument7 infrared1)
	(calibration_target instrument7 Star8)
	(calibration_target instrument7 GroundStation10)
	(calibration_target instrument7 GroundStation11)
	(calibration_target instrument7 GroundStation1)
	(supports instrument8 infrared4)
	(calibration_target instrument8 GroundStation9)
	(supports instrument9 thermograph2)
	(calibration_target instrument9 GroundStation5)
	(calibration_target instrument9 GroundStation12)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(on_board instrument7 satellite1)
	(on_board instrument8 satellite1)
	(on_board instrument9 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star7)
	(supports instrument10 image0)
	(supports instrument10 infrared5)
	(calibration_target instrument10 GroundStation1)
	(calibration_target instrument10 Star7)
	(supports instrument11 infrared5)
	(calibration_target instrument11 Star8)
	(calibration_target instrument11 Star0)
	(on_board instrument10 satellite2)
	(on_board instrument11 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star3)
)
(:goal (and
	(pointing satellite2 GroundStation10)
	(have_image Star13 thermograph2)
	(have_image Phenomenon14 infrared3)
	(have_image Phenomenon14 infrared5)
	(have_image Planet15 infrared5)
	(have_image Planet15 infrared4)
	(have_image Star16 thermograph2)
	(have_image Star16 infrared5)
))

)
