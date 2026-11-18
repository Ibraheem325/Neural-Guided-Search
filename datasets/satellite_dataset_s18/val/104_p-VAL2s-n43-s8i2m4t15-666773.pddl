(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
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
	instrument8 - instrument
	satellite6 - satellite
	instrument9 - instrument
	instrument10 - instrument
	satellite7 - satellite
	instrument11 - instrument
	instrument12 - instrument
	image0 - mode
	image3 - mode
	infrared1 - mode
	image2 - mode
	Star11 - direction
	GroundStation0 - direction
	Star4 - direction
	GroundStation10 - direction
	GroundStation2 - direction
	GroundStation14 - direction
	Star3 - direction
	GroundStation6 - direction
	Star5 - direction
	GroundStation1 - direction
	Star12 - direction
	GroundStation7 - direction
	Star13 - direction
	GroundStation9 - direction
	GroundStation8 - direction
	Star15 - direction
	Planet16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation9)
	(supports instrument1 image3)
	(supports instrument1 infrared1)
	(calibration_target instrument1 Star11)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 GroundStation0)
	(supports instrument2 infrared1)
	(calibration_target instrument2 GroundStation9)
	(calibration_target instrument2 GroundStation0)
	(calibration_target instrument2 Star3)
	(calibration_target instrument2 GroundStation7)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation9)
	(supports instrument3 image2)
	(calibration_target instrument3 GroundStation0)
	(calibration_target instrument3 Star11)
	(supports instrument4 infrared1)
	(calibration_target instrument4 Star12)
	(calibration_target instrument4 Star13)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation14)
	(supports instrument5 image3)
	(supports instrument5 infrared1)
	(supports instrument5 image2)
	(calibration_target instrument5 GroundStation7)
	(calibration_target instrument5 Star12)
	(calibration_target instrument5 GroundStation14)
	(calibration_target instrument5 Star5)
	(on_board instrument5 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet16)
	(supports instrument6 image3)
	(supports instrument6 infrared1)
	(calibration_target instrument6 Star12)
	(on_board instrument6 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation6)
	(supports instrument7 image0)
	(calibration_target instrument7 GroundStation7)
	(calibration_target instrument7 Star4)
	(supports instrument8 image2)
	(supports instrument8 image3)
	(supports instrument8 image0)
	(calibration_target instrument8 GroundStation14)
	(calibration_target instrument8 GroundStation2)
	(calibration_target instrument8 GroundStation10)
	(on_board instrument7 satellite5)
	(on_board instrument8 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Planet16)
	(supports instrument9 image0)
	(calibration_target instrument9 GroundStation14)
	(supports instrument10 image3)
	(supports instrument10 infrared1)
	(supports instrument10 image2)
	(calibration_target instrument10 Star3)
	(on_board instrument9 satellite6)
	(on_board instrument10 satellite6)
	(power_avail satellite6)
	(pointing satellite6 GroundStation7)
	(supports instrument11 image2)
	(supports instrument11 image3)
	(supports instrument11 infrared1)
	(calibration_target instrument11 Star12)
	(calibration_target instrument11 Star13)
	(calibration_target instrument11 GroundStation1)
	(calibration_target instrument11 Star5)
	(calibration_target instrument11 GroundStation6)
	(supports instrument12 image2)
	(supports instrument12 image0)
	(calibration_target instrument12 GroundStation8)
	(calibration_target instrument12 GroundStation9)
	(calibration_target instrument12 Star13)
	(calibration_target instrument12 GroundStation7)
	(on_board instrument11 satellite7)
	(on_board instrument12 satellite7)
	(power_avail satellite7)
	(pointing satellite7 GroundStation8)
)
(:goal (and
	(pointing satellite0 GroundStation7)
	(have_image Star15 infrared1)
	(have_image Planet16 image3)
	(have_image Phenomenon17 image2)
))

)
