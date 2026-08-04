(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	satellite3 - satellite
	instrument5 - instrument
	instrument6 - instrument
	satellite4 - satellite
	instrument7 - instrument
	satellite5 - satellite
	instrument8 - instrument
	satellite6 - satellite
	instrument9 - instrument
	thermograph3 - mode
	image0 - mode
	infrared1 - mode
	infrared2 - mode
	Star1 - direction
	GroundStation7 - direction
	GroundStation6 - direction
	Star8 - direction
	Star0 - direction
	GroundStation4 - direction
	Star3 - direction
	Star2 - direction
	GroundStation5 - direction
	Planet9 - direction
	Star10 - direction
	Planet11 - direction
	Star12 - direction
	Planet13 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 thermograph3)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 GroundStation5)
	(supports instrument1 image0)
	(supports instrument1 infrared2)
	(calibration_target instrument1 GroundStation6)
	(calibration_target instrument1 Star8)
	(calibration_target instrument1 GroundStation7)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet14)
	(supports instrument2 infrared1)
	(calibration_target instrument2 GroundStation5)
	(calibration_target instrument2 Star0)
	(calibration_target instrument2 Star8)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation7)
	(supports instrument3 image0)
	(supports instrument3 thermograph3)
	(supports instrument3 infrared1)
	(calibration_target instrument3 GroundStation6)
	(supports instrument4 image0)
	(supports instrument4 infrared1)
	(calibration_target instrument4 Star2)
	(calibration_target instrument4 GroundStation4)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star12)
	(supports instrument5 infrared2)
	(calibration_target instrument5 GroundStation6)
	(calibration_target instrument5 Star8)
	(calibration_target instrument5 GroundStation7)
	(supports instrument6 infrared2)
	(calibration_target instrument6 Star8)
	(calibration_target instrument6 Star3)
	(on_board instrument5 satellite3)
	(on_board instrument6 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star8)
	(supports instrument7 infrared2)
	(supports instrument7 image0)
	(supports instrument7 thermograph3)
	(calibration_target instrument7 GroundStation4)
	(calibration_target instrument7 Star0)
	(on_board instrument7 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star10)
	(supports instrument8 image0)
	(supports instrument8 infrared1)
	(supports instrument8 thermograph3)
	(calibration_target instrument8 Star2)
	(calibration_target instrument8 Star3)
	(on_board instrument8 satellite5)
	(power_avail satellite5)
	(pointing satellite5 GroundStation5)
	(supports instrument9 infrared1)
	(supports instrument9 infrared2)
	(calibration_target instrument9 GroundStation5)
	(on_board instrument9 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Planet11)
)
(:goal (and
	(have_image Planet9 image0)
	(have_image Star10 infrared1)
	(have_image Planet11 infrared1)
	(have_image Star12 infrared1)
	(have_image Planet13 thermograph3)
	(have_image Planet14 thermograph3)
	(have_image Phenomenon15 infrared1)
	(have_image Phenomenon16 infrared2)
	(have_image Star17 infrared2)
))

)
