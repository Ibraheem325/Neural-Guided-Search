(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	instrument3 - instrument
	satellite3 - satellite
	instrument4 - instrument
	satellite4 - satellite
	instrument5 - instrument
	satellite5 - satellite
	instrument6 - instrument
	instrument7 - instrument
	satellite6 - satellite
	instrument8 - instrument
	satellite7 - satellite
	instrument9 - instrument
	infrared0 - mode
	Star0 - direction
	GroundStation14 - direction
	GroundStation17 - direction
	GroundStation9 - direction
	GroundStation15 - direction
	Star7 - direction
	Star4 - direction
	GroundStation8 - direction
	GroundStation6 - direction
	GroundStation16 - direction
	Star10 - direction
	GroundStation11 - direction
	GroundStation13 - direction
	Star1 - direction
	GroundStation3 - direction
	Star5 - direction
	GroundStation12 - direction
	GroundStation18 - direction
	Star2 - direction
	Star19 - direction
	Star20 - direction
	Star21 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation15)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 GroundStation8)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation14)
	(supports instrument1 infrared0)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 GroundStation13)
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 GroundStation6)
	(calibration_target instrument1 GroundStation8)
	(calibration_target instrument1 GroundStation16)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star7)
	(supports instrument2 infrared0)
	(calibration_target instrument2 GroundStation3)
	(supports instrument3 infrared0)
	(calibration_target instrument3 GroundStation11)
	(calibration_target instrument3 Star7)
	(calibration_target instrument3 GroundStation15)
	(calibration_target instrument3 Star1)
	(calibration_target instrument3 Star4)
	(calibration_target instrument3 GroundStation3)
	(on_board instrument2 satellite2)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star5)
	(supports instrument4 infrared0)
	(calibration_target instrument4 GroundStation8)
	(calibration_target instrument4 GroundStation13)
	(calibration_target instrument4 GroundStation16)
	(calibration_target instrument4 GroundStation6)
	(calibration_target instrument4 Star4)
	(on_board instrument4 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation13)
	(supports instrument5 infrared0)
	(calibration_target instrument5 GroundStation18)
	(on_board instrument5 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star10)
	(supports instrument6 infrared0)
	(calibration_target instrument6 GroundStation13)
	(supports instrument7 infrared0)
	(calibration_target instrument7 Star2)
	(calibration_target instrument7 GroundStation16)
	(calibration_target instrument7 GroundStation12)
	(calibration_target instrument7 GroundStation6)
	(on_board instrument6 satellite5)
	(on_board instrument7 satellite5)
	(power_avail satellite5)
	(pointing satellite5 GroundStation14)
	(supports instrument8 infrared0)
	(calibration_target instrument8 Star1)
	(calibration_target instrument8 GroundStation13)
	(calibration_target instrument8 GroundStation11)
	(calibration_target instrument8 Star10)
	(on_board instrument8 satellite6)
	(power_avail satellite6)
	(pointing satellite6 GroundStation13)
	(supports instrument9 infrared0)
	(calibration_target instrument9 Star2)
	(calibration_target instrument9 GroundStation18)
	(calibration_target instrument9 GroundStation12)
	(calibration_target instrument9 Star5)
	(calibration_target instrument9 GroundStation3)
	(on_board instrument9 satellite7)
	(power_avail satellite7)
	(pointing satellite7 GroundStation18)
)
(:goal (and
	(pointing satellite1 Star0)
	(pointing satellite3 Star19)
	(pointing satellite4 GroundStation12)
	(pointing satellite7 GroundStation9)
	(have_image Star19 infrared0)
	(have_image Star20 infrared0)
	(have_image Star21 infrared0)
))

)
