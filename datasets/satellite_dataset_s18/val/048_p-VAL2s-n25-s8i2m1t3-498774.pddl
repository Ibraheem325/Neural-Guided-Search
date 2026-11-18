(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	satellite5 - satellite
	instrument5 - instrument
	instrument6 - instrument
	satellite6 - satellite
	instrument7 - instrument
	satellite7 - satellite
	instrument8 - instrument
	instrument9 - instrument
	image0 - mode
	GroundStation1 - direction
	Star0 - direction
	Star2 - direction
	Star3 - direction
	Phenomenon4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star3)
	(supports instrument2 image0)
	(calibration_target instrument2 Star0)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet5)
	(supports instrument3 image0)
	(calibration_target instrument3 Star0)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet5)
	(supports instrument4 image0)
	(calibration_target instrument4 Star0)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star3)
	(supports instrument5 image0)
	(calibration_target instrument5 Star2)
	(supports instrument6 image0)
	(calibration_target instrument6 GroundStation1)
	(on_board instrument5 satellite5)
	(on_board instrument6 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Star3)
	(supports instrument7 image0)
	(calibration_target instrument7 Star0)
	(on_board instrument7 satellite6)
	(power_avail satellite6)
	(pointing satellite6 GroundStation1)
	(supports instrument8 image0)
	(calibration_target instrument8 Star2)
	(supports instrument9 image0)
	(calibration_target instrument9 Star2)
	(on_board instrument8 satellite7)
	(on_board instrument9 satellite7)
	(power_avail satellite7)
	(pointing satellite7 Phenomenon4)
)
(:goal (and
	(pointing satellite0 Phenomenon4)
	(pointing satellite1 Star2)
	(pointing satellite5 GroundStation1)
	(pointing satellite6 Phenomenon4)
	(have_image Star3 image0)
	(have_image Phenomenon4 image0)
	(have_image Planet5 image0)
))

)
