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
	infrared0 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Planet3 - direction
	Phenomenon4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet3)
	(supports instrument1 infrared0)
	(calibration_target instrument1 GroundStation2)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star0)
	(supports instrument2 infrared0)
	(calibration_target instrument2 Star0)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet5)
	(supports instrument3 infrared0)
	(calibration_target instrument3 Star1)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star0)
	(supports instrument4 infrared0)
	(calibration_target instrument4 Star1)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Phenomenon4)
	(supports instrument5 infrared0)
	(calibration_target instrument5 GroundStation2)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Star0)
	(supports instrument6 infrared0)
	(calibration_target instrument6 GroundStation2)
	(on_board instrument6 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Planet5)
)
(:goal (and
	(pointing satellite4 Star0)
	(have_image Planet3 infrared0)
	(have_image Phenomenon4 infrared0)
	(have_image Planet5 infrared0)
))

)
