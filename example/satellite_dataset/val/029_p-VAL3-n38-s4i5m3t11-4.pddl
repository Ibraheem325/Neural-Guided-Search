(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	instrument6 - instrument
	satellite3 - satellite
	instrument7 - instrument
	instrument8 - instrument
	instrument9 - instrument
	instrument10 - instrument
	instrument11 - instrument
	thermograph0 - mode
	infrared1 - mode
	infrared2 - mode
	GroundStation3 - direction
	GroundStation4 - direction
	Star8 - direction
	GroundStation6 - direction
	Star0 - direction
	Star9 - direction
	Star1 - direction
	GroundStation7 - direction
	Star2 - direction
	GroundStation5 - direction
	Star10 - direction
	Planet11 - direction
	Planet12 - direction
	Phenomenon13 - direction
	Star14 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 GroundStation5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet11)
	(supports instrument1 infrared2)
	(supports instrument1 thermograph0)
	(supports instrument1 infrared1)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 Star1)
	(supports instrument2 infrared2)
	(calibration_target instrument2 Star0)
	(calibration_target instrument2 Star1)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star8)
	(supports instrument3 infrared2)
	(calibration_target instrument3 Star8)
	(supports instrument4 thermograph0)
	(supports instrument4 infrared1)
	(calibration_target instrument4 Star8)
	(supports instrument5 infrared1)
	(supports instrument5 infrared2)
	(calibration_target instrument5 Star9)
	(calibration_target instrument5 Star10)
	(supports instrument6 thermograph0)
	(supports instrument6 infrared2)
	(supports instrument6 infrared1)
	(calibration_target instrument6 Star2)
	(calibration_target instrument6 GroundStation6)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation5)
	(supports instrument7 infrared1)
	(calibration_target instrument7 GroundStation5)
	(calibration_target instrument7 Star0)
	(supports instrument8 infrared1)
	(supports instrument8 infrared2)
	(supports instrument8 thermograph0)
	(calibration_target instrument8 Star9)
	(calibration_target instrument8 Star10)
	(supports instrument9 infrared2)
	(supports instrument9 thermograph0)
	(calibration_target instrument9 Star10)
	(supports instrument10 infrared2)
	(calibration_target instrument10 Star2)
	(calibration_target instrument10 GroundStation7)
	(calibration_target instrument10 Star1)
	(supports instrument11 infrared1)
	(calibration_target instrument11 Star10)
	(calibration_target instrument11 GroundStation5)
	(on_board instrument7 satellite3)
	(on_board instrument8 satellite3)
	(on_board instrument9 satellite3)
	(on_board instrument10 satellite3)
	(on_board instrument11 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star0)
)
(:goal (and
	(pointing satellite0 GroundStation5)
	(pointing satellite1 Star2)
	(pointing satellite2 Star8)
	(have_image Planet11 infrared2)
	(have_image Planet12 thermograph0)
	(have_image Phenomenon13 infrared1)
	(have_image Star14 thermograph0)
))

)
