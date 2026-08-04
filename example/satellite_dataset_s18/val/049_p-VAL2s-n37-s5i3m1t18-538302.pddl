(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	satellite3 - satellite
	instrument5 - instrument
	instrument6 - instrument
	instrument7 - instrument
	satellite4 - satellite
	instrument8 - instrument
	image0 - mode
	GroundStation5 - direction
	GroundStation12 - direction
	GroundStation7 - direction
	Star0 - direction
	GroundStation11 - direction
	Star3 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	Star16 - direction
	GroundStation17 - direction
	Star15 - direction
	Star6 - direction
	Star1 - direction
	Star10 - direction
	GroundStation14 - direction
	Star13 - direction
	Phenomenon18 - direction
	Star19 - direction
	Planet20 - direction
	Phenomenon21 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation11)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
	(supports instrument1 image0)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 GroundStation11)
	(calibration_target instrument1 Star0)
	(calibration_target instrument1 Star10)
	(calibration_target instrument1 GroundStation7)
	(supports instrument2 image0)
	(calibration_target instrument2 GroundStation9)
	(supports instrument3 image0)
	(calibration_target instrument3 Star6)
	(calibration_target instrument3 GroundStation2)
	(calibration_target instrument3 GroundStation14)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 Star3)
	(calibration_target instrument3 Star1)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon21)
	(supports instrument4 image0)
	(calibration_target instrument4 Star6)
	(calibration_target instrument4 GroundStation9)
	(calibration_target instrument4 Star10)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation2)
	(supports instrument5 image0)
	(calibration_target instrument5 GroundStation2)
	(calibration_target instrument5 Star16)
	(supports instrument6 image0)
	(calibration_target instrument6 GroundStation17)
	(calibration_target instrument6 Star16)
	(calibration_target instrument6 GroundStation4)
	(calibration_target instrument6 GroundStation14)
	(supports instrument7 image0)
	(calibration_target instrument7 Star6)
	(calibration_target instrument7 GroundStation14)
	(on_board instrument5 satellite3)
	(on_board instrument6 satellite3)
	(on_board instrument7 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation7)
	(supports instrument8 image0)
	(calibration_target instrument8 Star13)
	(calibration_target instrument8 GroundStation14)
	(calibration_target instrument8 Star10)
	(calibration_target instrument8 Star1)
	(calibration_target instrument8 Star6)
	(calibration_target instrument8 Star15)
	(on_board instrument8 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation2)
)
(:goal (and
	(pointing satellite0 Planet20)
	(pointing satellite1 Star3)
	(pointing satellite4 GroundStation2)
	(have_image Phenomenon18 image0)
	(have_image Star19 image0)
	(have_image Planet20 image0)
	(have_image Phenomenon21 image0)
))

)
