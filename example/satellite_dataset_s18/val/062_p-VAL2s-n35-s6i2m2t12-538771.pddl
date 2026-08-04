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
	satellite3 - satellite
	instrument4 - instrument
	satellite4 - satellite
	instrument5 - instrument
	satellite5 - satellite
	instrument6 - instrument
	infrared1 - mode
	infrared0 - mode
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation10 - direction
	Star9 - direction
	GroundStation11 - direction
	Star3 - direction
	Star0 - direction
	GroundStation1 - direction
	Star4 - direction
	Star5 - direction
	GroundStation2 - direction
	GroundStation6 - direction
	Planet12 - direction
	Planet13 - direction
	Phenomenon14 - direction
	Star15 - direction
	Planet16 - direction
	Star17 - direction
	Phenomenon18 - direction
	Star19 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star4)
	(supports instrument1 infrared1)
	(supports instrument1 infrared0)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 GroundStation2)
	(calibration_target instrument1 GroundStation8)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation2)
	(supports instrument2 infrared1)
	(supports instrument2 infrared0)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 Star9)
	(calibration_target instrument2 GroundStation6)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star5)
	(supports instrument3 infrared1)
	(supports instrument3 infrared0)
	(calibration_target instrument3 Star5)
	(calibration_target instrument3 Star3)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation1)
	(supports instrument4 infrared0)
	(supports instrument4 infrared1)
	(calibration_target instrument4 Star5)
	(calibration_target instrument4 GroundStation11)
	(on_board instrument4 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star0)
	(supports instrument5 infrared0)
	(supports instrument5 infrared1)
	(calibration_target instrument5 Star4)
	(calibration_target instrument5 GroundStation1)
	(calibration_target instrument5 Star0)
	(calibration_target instrument5 Star3)
	(on_board instrument5 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation8)
	(supports instrument6 infrared1)
	(calibration_target instrument6 GroundStation6)
	(calibration_target instrument6 GroundStation2)
	(calibration_target instrument6 Star5)
	(on_board instrument6 satellite5)
	(power_avail satellite5)
	(pointing satellite5 GroundStation2)
)
(:goal (and
	(pointing satellite1 GroundStation7)
	(pointing satellite2 Star5)
	(have_image Planet12 infrared0)
	(have_image Planet13 infrared0)
	(have_image Phenomenon14 infrared0)
	(have_image Star15 infrared0)
	(have_image Planet16 infrared1)
	(have_image Star17 infrared1)
	(have_image Phenomenon18 infrared1)
	(have_image Star19 infrared0)
))

)
