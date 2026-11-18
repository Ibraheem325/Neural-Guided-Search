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
	satellite4 - satellite
	instrument6 - instrument
	satellite5 - satellite
	instrument7 - instrument
	satellite6 - satellite
	instrument8 - instrument
	instrument9 - instrument
	image0 - mode
	image1 - mode
	GroundStation7 - direction
	GroundStation16 - direction
	GroundStation2 - direction
	Star13 - direction
	Star3 - direction
	Star9 - direction
	GroundStation17 - direction
	Star4 - direction
	GroundStation19 - direction
	Star18 - direction
	Star5 - direction
	Star15 - direction
	GroundStation0 - direction
	Star6 - direction
	Star10 - direction
	Star1 - direction
	Star14 - direction
	GroundStation11 - direction
	Star8 - direction
	GroundStation12 - direction
	Star20 - direction
	Planet21 - direction
	Planet22 - direction
	Phenomenon23 - direction
)
(:init
	(supports instrument0 image1)
	(calibration_target instrument0 Star18)
	(calibration_target instrument0 Star14)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 GroundStation19)
	(supports instrument1 image0)
	(supports instrument1 image1)
	(calibration_target instrument1 GroundStation0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
	(supports instrument2 image1)
	(supports instrument2 image0)
	(calibration_target instrument2 GroundStation19)
	(calibration_target instrument2 Star6)
	(calibration_target instrument2 GroundStation11)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 Star9)
	(calibration_target instrument2 Star3)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star4)
	(supports instrument3 image0)
	(calibration_target instrument3 Star3)
	(calibration_target instrument3 GroundStation11)
	(calibration_target instrument3 Star18)
	(calibration_target instrument3 Star9)
	(calibration_target instrument3 Star8)
	(calibration_target instrument3 Star14)
	(supports instrument4 image1)
	(calibration_target instrument4 Star10)
	(calibration_target instrument4 Star13)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star8)
	(supports instrument5 image0)
	(supports instrument5 image1)
	(calibration_target instrument5 Star13)
	(calibration_target instrument5 Star4)
	(calibration_target instrument5 GroundStation19)
	(calibration_target instrument5 Star14)
	(calibration_target instrument5 GroundStation11)
	(on_board instrument5 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation7)
	(supports instrument6 image0)
	(supports instrument6 image1)
	(calibration_target instrument6 Star4)
	(calibration_target instrument6 GroundStation17)
	(calibration_target instrument6 Star9)
	(calibration_target instrument6 GroundStation12)
	(calibration_target instrument6 Star3)
	(calibration_target instrument6 Star18)
	(on_board instrument6 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation12)
	(supports instrument7 image0)
	(supports instrument7 image1)
	(calibration_target instrument7 Star15)
	(calibration_target instrument7 Star8)
	(calibration_target instrument7 GroundStation19)
	(on_board instrument7 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Planet21)
	(supports instrument8 image1)
	(supports instrument8 image0)
	(calibration_target instrument8 Star6)
	(calibration_target instrument8 GroundStation0)
	(calibration_target instrument8 Star15)
	(calibration_target instrument8 Star5)
	(calibration_target instrument8 Star18)
	(calibration_target instrument8 GroundStation19)
	(supports instrument9 image0)
	(calibration_target instrument9 GroundStation12)
	(calibration_target instrument9 Star8)
	(calibration_target instrument9 GroundStation11)
	(calibration_target instrument9 Star14)
	(calibration_target instrument9 Star1)
	(calibration_target instrument9 Star10)
	(on_board instrument8 satellite6)
	(on_board instrument9 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Phenomenon23)
)
(:goal (and
	(pointing satellite0 GroundStation17)
	(pointing satellite3 Star8)
	(pointing satellite4 Star20)
	(pointing satellite6 GroundStation0)
	(have_image Star20 image1)
	(have_image Planet21 image1)
	(have_image Planet22 image0)
	(have_image Phenomenon23 image0)
))

)
