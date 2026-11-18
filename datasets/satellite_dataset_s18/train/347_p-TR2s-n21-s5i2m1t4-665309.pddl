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
	instrument5 - instrument
	satellite4 - satellite
	instrument6 - instrument
	infrared0 - mode
	GroundStation1 - direction
	Star2 - direction
	Star0 - direction
	GroundStation3 - direction
	Star4 - direction
	Planet5 - direction
	Planet6 - direction
	Star7 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
	(supports instrument1 infrared0)
	(calibration_target instrument1 Star0)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet6)
	(supports instrument2 infrared0)
	(calibration_target instrument2 Star2)
	(supports instrument3 infrared0)
	(calibration_target instrument3 Star0)
	(on_board instrument2 satellite2)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet6)
	(supports instrument4 infrared0)
	(calibration_target instrument4 Star2)
	(supports instrument5 infrared0)
	(calibration_target instrument5 Star0)
	(on_board instrument4 satellite3)
	(on_board instrument5 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet6)
	(supports instrument6 infrared0)
	(calibration_target instrument6 GroundStation3)
	(on_board instrument6 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Planet6)
)
(:goal (and
	(pointing satellite0 GroundStation1)
	(pointing satellite1 Star2)
	(pointing satellite2 Star7)
	(have_image Star4 infrared0)
	(have_image Planet5 infrared0)
	(have_image Planet6 infrared0)
	(have_image Star7 infrared0)
))

)
