(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	instrument5 - instrument
	satellite3 - satellite
	instrument6 - instrument
	satellite4 - satellite
	instrument7 - instrument
	infrared0 - mode
	Star2 - direction
	Star0 - direction
	Star7 - direction
	Star4 - direction
	GroundStation8 - direction
	GroundStation10 - direction
	Star3 - direction
	Star9 - direction
	GroundStation1 - direction
	Star5 - direction
	Star6 - direction
	Planet11 - direction
	Phenomenon12 - direction
	Star13 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Planet17 - direction
	Planet18 - direction
	Phenomenon19 - direction
	Planet20 - direction
	Star21 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star4)
	(supports instrument1 infrared0)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 Star2)
	(calibration_target instrument1 Star5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon19)
	(supports instrument2 infrared0)
	(calibration_target instrument2 Star3)
	(calibration_target instrument2 Star0)
	(supports instrument3 infrared0)
	(calibration_target instrument3 Star7)
	(calibration_target instrument3 Star3)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star9)
	(supports instrument4 infrared0)
	(calibration_target instrument4 Star9)
	(calibration_target instrument4 GroundStation8)
	(calibration_target instrument4 Star4)
	(supports instrument5 infrared0)
	(calibration_target instrument5 GroundStation10)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation8)
	(supports instrument6 infrared0)
	(calibration_target instrument6 Star5)
	(calibration_target instrument6 Star9)
	(calibration_target instrument6 Star3)
	(on_board instrument6 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star9)
	(supports instrument7 infrared0)
	(calibration_target instrument7 Star6)
	(calibration_target instrument7 Star5)
	(calibration_target instrument7 GroundStation1)
	(on_board instrument7 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Planet20)
)
(:goal (and
	(pointing satellite1 Star5)
	(pointing satellite2 Phenomenon12)
	(pointing satellite4 GroundStation10)
	(have_image Planet11 infrared0)
	(have_image Phenomenon12 infrared0)
	(have_image Star13 infrared0)
	(have_image Planet14 infrared0)
	(have_image Phenomenon15 infrared0)
	(have_image Star16 infrared0)
	(have_image Planet17 infrared0)
	(have_image Planet18 infrared0)
	(have_image Phenomenon19 infrared0)
	(have_image Planet20 infrared0)
	(have_image Star21 infrared0)
))

)
