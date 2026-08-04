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
	instrument6 - instrument
	satellite5 - satellite
	instrument7 - instrument
	instrument8 - instrument
	image0 - mode
	GroundStation4 - direction
	Star6 - direction
	GroundStation1 - direction
	Star7 - direction
	GroundStation14 - direction
	Star3 - direction
	GroundStation2 - direction
	Star11 - direction
	Star10 - direction
	GroundStation8 - direction
	Star9 - direction
	GroundStation0 - direction
	GroundStation5 - direction
	GroundStation13 - direction
	GroundStation12 - direction
	Planet15 - direction
	Planet16 - direction
	Planet17 - direction
	Phenomenon18 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation12)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star7)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation2)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star11)
	(supports instrument2 image0)
	(calibration_target instrument2 Star11)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 GroundStation5)
	(calibration_target instrument2 Star7)
	(calibration_target instrument2 Star6)
	(supports instrument3 image0)
	(calibration_target instrument3 Star9)
	(calibration_target instrument3 Star3)
	(calibration_target instrument3 Star11)
	(calibration_target instrument3 GroundStation1)
	(on_board instrument2 satellite2)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star10)
	(supports instrument4 image0)
	(calibration_target instrument4 GroundStation1)
	(calibration_target instrument4 GroundStation0)
	(calibration_target instrument4 GroundStation14)
	(calibration_target instrument4 Star11)
	(calibration_target instrument4 GroundStation12)
	(on_board instrument4 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star11)
	(supports instrument5 image0)
	(calibration_target instrument5 GroundStation13)
	(calibration_target instrument5 Star7)
	(calibration_target instrument5 Star11)
	(calibration_target instrument5 GroundStation12)
	(calibration_target instrument5 Star9)
	(supports instrument6 image0)
	(calibration_target instrument6 Star10)
	(calibration_target instrument6 Star11)
	(calibration_target instrument6 GroundStation2)
	(calibration_target instrument6 Star3)
	(calibration_target instrument6 GroundStation14)
	(on_board instrument5 satellite4)
	(on_board instrument6 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation5)
	(supports instrument7 image0)
	(calibration_target instrument7 GroundStation5)
	(calibration_target instrument7 GroundStation0)
	(calibration_target instrument7 GroundStation13)
	(calibration_target instrument7 Star9)
	(calibration_target instrument7 GroundStation8)
	(supports instrument8 image0)
	(calibration_target instrument8 GroundStation12)
	(calibration_target instrument8 GroundStation13)
	(calibration_target instrument8 GroundStation5)
	(on_board instrument7 satellite5)
	(on_board instrument8 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Star10)
)
(:goal (and
	(pointing satellite0 Star6)
	(pointing satellite1 Phenomenon18)
	(pointing satellite3 GroundStation14)
	(have_image Planet15 image0)
	(have_image Planet16 image0)
	(have_image Planet17 image0)
	(have_image Phenomenon18 image0)
))

)
