(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	satellite1 - satellite
	instrument4 - instrument
	instrument5 - instrument
	satellite2 - satellite
	instrument6 - instrument
	satellite3 - satellite
	instrument7 - instrument
	instrument8 - instrument
	instrument9 - instrument
	instrument10 - instrument
	instrument11 - instrument
	satellite4 - satellite
	instrument12 - instrument
	instrument13 - instrument
	infrared1 - mode
	infrared2 - mode
	thermograph0 - mode
	Star12 - direction
	GroundStation13 - direction
	Star1 - direction
	Star9 - direction
	Star10 - direction
	Star8 - direction
	GroundStation11 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation6 - direction
	Star0 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	GroundStation7 - direction
	Star14 - direction
	Star15 - direction
	Phenomenon16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 thermograph0)
	(supports instrument0 infrared2)
	(calibration_target instrument0 GroundStation13)
	(supports instrument1 infrared2)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 Star1)
	(supports instrument2 thermograph0)
	(supports instrument2 infrared2)
	(calibration_target instrument2 Star10)
	(supports instrument3 infrared1)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 GroundStation3)
	(calibration_target instrument3 Star9)
	(calibration_target instrument3 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
	(supports instrument4 infrared1)
	(supports instrument4 thermograph0)
	(supports instrument4 infrared2)
	(calibration_target instrument4 Star8)
	(calibration_target instrument4 Star2)
	(calibration_target instrument4 Star9)
	(calibration_target instrument4 Star0)
	(supports instrument5 thermograph0)
	(supports instrument5 infrared1)
	(supports instrument5 infrared2)
	(calibration_target instrument5 Star9)
	(calibration_target instrument5 Star0)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon17)
	(supports instrument6 infrared2)
	(calibration_target instrument6 GroundStation4)
	(calibration_target instrument6 GroundStation6)
	(calibration_target instrument6 Star10)
	(calibration_target instrument6 Star9)
	(on_board instrument6 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation5)
	(supports instrument7 infrared1)
	(calibration_target instrument7 Star10)
	(calibration_target instrument7 Star8)
	(calibration_target instrument7 Star9)
	(supports instrument8 infrared1)
	(supports instrument8 infrared2)
	(calibration_target instrument8 GroundStation5)
	(calibration_target instrument8 Star10)
	(supports instrument9 infrared1)
	(calibration_target instrument9 Star0)
	(calibration_target instrument9 Star2)
	(calibration_target instrument9 Star8)
	(calibration_target instrument9 Star10)
	(supports instrument10 thermograph0)
	(calibration_target instrument10 GroundStation11)
	(supports instrument11 thermograph0)
	(supports instrument11 infrared2)
	(supports instrument11 infrared1)
	(calibration_target instrument11 Star2)
	(on_board instrument7 satellite3)
	(on_board instrument8 satellite3)
	(on_board instrument9 satellite3)
	(on_board instrument10 satellite3)
	(on_board instrument11 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star12)
	(supports instrument12 infrared1)
	(supports instrument12 infrared2)
	(supports instrument12 thermograph0)
	(calibration_target instrument12 Star0)
	(calibration_target instrument12 GroundStation6)
	(calibration_target instrument12 GroundStation3)
	(supports instrument13 infrared2)
	(calibration_target instrument13 GroundStation7)
	(calibration_target instrument13 GroundStation5)
	(calibration_target instrument13 GroundStation4)
	(calibration_target instrument13 Star0)
	(on_board instrument12 satellite4)
	(on_board instrument13 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation5)
)
(:goal (and
	(pointing satellite0 Star12)
	(pointing satellite2 GroundStation11)
	(pointing satellite3 Star12)
	(have_image Star14 thermograph0)
	(have_image Star15 infrared2)
	(have_image Phenomenon16 infrared1)
	(have_image Phenomenon17 infrared2)
))

)
