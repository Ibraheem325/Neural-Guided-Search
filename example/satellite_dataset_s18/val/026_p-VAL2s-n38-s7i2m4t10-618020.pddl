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
	instrument4 - instrument
	satellite4 - satellite
	instrument5 - instrument
	satellite5 - satellite
	instrument6 - instrument
	satellite6 - satellite
	instrument7 - instrument
	instrument8 - instrument
	infrared3 - mode
	infrared1 - mode
	image0 - mode
	image2 - mode
	GroundStation6 - direction
	GroundStation8 - direction
	Star3 - direction
	GroundStation4 - direction
	Star1 - direction
	GroundStation7 - direction
	Star9 - direction
	GroundStation0 - direction
	GroundStation2 - direction
	Star5 - direction
	Planet10 - direction
	Star11 - direction
	Planet12 - direction
	Phenomenon13 - direction
	Star14 - direction
	Planet15 - direction
	Star16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 infrared1)
	(supports instrument0 image0)
	(calibration_target instrument0 Star9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star11)
	(supports instrument1 infrared3)
	(calibration_target instrument1 Star3)
	(calibration_target instrument1 GroundStation8)
	(calibration_target instrument1 GroundStation0)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet10)
	(supports instrument2 image0)
	(supports instrument2 infrared1)
	(supports instrument2 image2)
	(calibration_target instrument2 Star5)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 GroundStation4)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star11)
	(supports instrument3 infrared1)
	(supports instrument3 image2)
	(supports instrument3 infrared3)
	(calibration_target instrument3 Star9)
	(supports instrument4 infrared3)
	(supports instrument4 image2)
	(calibration_target instrument4 GroundStation2)
	(on_board instrument3 satellite3)
	(on_board instrument4 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation0)
	(supports instrument5 image2)
	(calibration_target instrument5 GroundStation2)
	(calibration_target instrument5 Star9)
	(on_board instrument5 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Planet10)
	(supports instrument6 infrared3)
	(supports instrument6 infrared1)
	(supports instrument6 image2)
	(calibration_target instrument6 Star5)
	(calibration_target instrument6 GroundStation7)
	(calibration_target instrument6 Star1)
	(on_board instrument6 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Planet15)
	(supports instrument7 image0)
	(supports instrument7 infrared1)
	(supports instrument7 infrared3)
	(calibration_target instrument7 Star9)
	(supports instrument8 infrared3)
	(supports instrument8 image0)
	(supports instrument8 infrared1)
	(calibration_target instrument8 Star5)
	(calibration_target instrument8 GroundStation2)
	(calibration_target instrument8 GroundStation0)
	(on_board instrument7 satellite6)
	(on_board instrument8 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Star16)
)
(:goal (and
	(pointing satellite1 Planet10)
	(pointing satellite6 Star9)
	(have_image Planet10 image2)
	(have_image Star11 image0)
	(have_image Planet12 image2)
	(have_image Phenomenon13 infrared3)
	(have_image Star14 infrared1)
	(have_image Planet15 infrared3)
	(have_image Star16 infrared1)
	(have_image Star17 image2)
))

)
