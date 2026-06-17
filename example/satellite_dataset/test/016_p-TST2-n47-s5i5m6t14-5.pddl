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
	satellite3 - satellite
	instrument9 - instrument
	instrument10 - instrument
	satellite4 - satellite
	instrument11 - instrument
	instrument12 - instrument
	instrument13 - instrument
	thermograph2 - mode
	image0 - mode
	infrared3 - mode
	infrared4 - mode
	infrared5 - mode
	infrared1 - mode
	Star0 - direction
	GroundStation10 - direction
	Star3 - direction
	Star13 - direction
	Star4 - direction
	Star7 - direction
	GroundStation5 - direction
	GroundStation9 - direction
	Star8 - direction
	GroundStation6 - direction
	GroundStation12 - direction
	Star2 - direction
	GroundStation1 - direction
	GroundStation11 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 image0)
	(supports instrument1 infrared5)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 Star7)
	(calibration_target instrument1 Star3)
	(supports instrument2 infrared1)
	(supports instrument2 infrared5)
	(supports instrument2 infrared4)
	(calibration_target instrument2 Star2)
	(supports instrument3 infrared1)
	(calibration_target instrument3 Star4)
	(calibration_target instrument3 GroundStation9)
	(calibration_target instrument3 Star0)
	(calibration_target instrument3 Star7)
	(supports instrument4 infrared1)
	(calibration_target instrument4 Star0)
	(calibration_target instrument4 Star7)
	(calibration_target instrument4 GroundStation6)
	(calibration_target instrument4 GroundStation11)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(on_board instrument4 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation12)
	(supports instrument5 image0)
	(supports instrument5 infrared4)
	(calibration_target instrument5 Star13)
	(calibration_target instrument5 Star3)
	(calibration_target instrument5 GroundStation10)
	(supports instrument6 infrared5)
	(supports instrument6 infrared1)
	(calibration_target instrument6 GroundStation9)
	(calibration_target instrument6 Star2)
	(calibration_target instrument6 Star4)
	(supports instrument7 infrared3)
	(calibration_target instrument7 GroundStation6)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(on_board instrument7 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation6)
	(supports instrument8 image0)
	(supports instrument8 infrared1)
	(supports instrument8 thermograph2)
	(calibration_target instrument8 Star2)
	(calibration_target instrument8 Star7)
	(calibration_target instrument8 Star8)
	(calibration_target instrument8 GroundStation9)
	(on_board instrument8 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star7)
	(supports instrument9 thermograph2)
	(calibration_target instrument9 GroundStation11)
	(calibration_target instrument9 GroundStation6)
	(calibration_target instrument9 GroundStation12)
	(supports instrument10 infrared5)
	(supports instrument10 infrared1)
	(supports instrument10 infrared4)
	(calibration_target instrument10 GroundStation9)
	(calibration_target instrument10 GroundStation5)
	(calibration_target instrument10 Star8)
	(calibration_target instrument10 GroundStation11)
	(on_board instrument9 satellite3)
	(on_board instrument10 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star16)
	(supports instrument11 image0)
	(calibration_target instrument11 Star8)
	(calibration_target instrument11 GroundStation9)
	(calibration_target instrument11 GroundStation5)
	(supports instrument12 infrared1)
	(supports instrument12 thermograph2)
	(calibration_target instrument12 GroundStation1)
	(calibration_target instrument12 Star2)
	(calibration_target instrument12 GroundStation12)
	(calibration_target instrument12 GroundStation6)
	(supports instrument13 infrared4)
	(supports instrument13 image0)
	(calibration_target instrument13 GroundStation11)
	(on_board instrument11 satellite4)
	(on_board instrument12 satellite4)
	(on_board instrument13 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation10)
)
(:goal (and
	(pointing satellite3 GroundStation12)
	(have_image Planet14 infrared3)
	(have_image Planet14 image0)
	(have_image Phenomenon15 infrared3)
	(have_image Star16 infrared1)
	(have_image Star17 image0)
))

)
