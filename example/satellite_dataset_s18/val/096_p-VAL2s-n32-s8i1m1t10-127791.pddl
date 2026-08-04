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
	satellite6 - satellite
	instrument6 - instrument
	satellite7 - satellite
	instrument7 - instrument
	infrared0 - mode
	GroundStation1 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation2 - direction
	GroundStation0 - direction
	Star7 - direction
	Star8 - direction
	Star3 - direction
	Star6 - direction
	Star9 - direction
	Phenomenon10 - direction
	Phenomenon11 - direction
	Planet12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
	(supports instrument1 infrared0)
	(calibration_target instrument1 Star7)
	(calibration_target instrument1 Star8)
	(calibration_target instrument1 Star9)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star3)
	(supports instrument2 infrared0)
	(calibration_target instrument2 Star3)
	(calibration_target instrument2 GroundStation2)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon11)
	(supports instrument3 infrared0)
	(calibration_target instrument3 Star8)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star3)
	(supports instrument4 infrared0)
	(calibration_target instrument4 Star7)
	(calibration_target instrument4 GroundStation0)
	(calibration_target instrument4 Star9)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Planet12)
	(supports instrument5 infrared0)
	(calibration_target instrument5 Star8)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Planet12)
	(supports instrument6 infrared0)
	(calibration_target instrument6 Star3)
	(calibration_target instrument6 Star6)
	(calibration_target instrument6 Star9)
	(on_board instrument6 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Star5)
	(supports instrument7 infrared0)
	(calibration_target instrument7 Star9)
	(calibration_target instrument7 Star6)
	(on_board instrument7 satellite7)
	(power_avail satellite7)
	(pointing satellite7 Phenomenon14)
)
(:goal (and
	(pointing satellite2 Phenomenon13)
	(pointing satellite3 Planet12)
	(have_image Phenomenon10 infrared0)
	(have_image Phenomenon11 infrared0)
	(have_image Planet12 infrared0)
	(have_image Phenomenon13 infrared0)
	(have_image Phenomenon14 infrared0)
))

)
