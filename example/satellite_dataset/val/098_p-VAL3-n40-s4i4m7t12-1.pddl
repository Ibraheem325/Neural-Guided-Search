(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	satellite2 - satellite
	instrument6 - instrument
	instrument7 - instrument
	instrument8 - instrument
	instrument9 - instrument
	satellite3 - satellite
	instrument10 - instrument
	instrument11 - instrument
	instrument12 - instrument
	thermograph3 - mode
	thermograph2 - mode
	image6 - mode
	thermograph4 - mode
	image1 - mode
	infrared5 - mode
	thermograph0 - mode
	GroundStation7 - direction
	Star1 - direction
	Star5 - direction
	GroundStation0 - direction
	Star3 - direction
	Star10 - direction
	Star6 - direction
	GroundStation11 - direction
	GroundStation9 - direction
	GroundStation4 - direction
	GroundStation8 - direction
	GroundStation2 - direction
	Star12 - direction
	Star13 - direction
	Planet14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 image6)
	(supports instrument0 thermograph2)
	(supports instrument0 thermograph3)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 Star1)
	(supports instrument1 thermograph3)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 GroundStation9)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet15)
	(supports instrument2 image6)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 Star6)
	(calibration_target instrument2 GroundStation7)
	(supports instrument3 infrared5)
	(calibration_target instrument3 GroundStation2)
	(supports instrument4 thermograph4)
	(supports instrument4 image1)
	(calibration_target instrument4 GroundStation11)
	(supports instrument5 thermograph3)
	(supports instrument5 infrared5)
	(calibration_target instrument5 Star3)
	(calibration_target instrument5 GroundStation4)
	(calibration_target instrument5 GroundStation2)
	(calibration_target instrument5 Star1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation2)
	(supports instrument6 thermograph3)
	(supports instrument6 thermograph0)
	(calibration_target instrument6 GroundStation0)
	(calibration_target instrument6 GroundStation2)
	(supports instrument7 thermograph3)
	(calibration_target instrument7 Star5)
	(calibration_target instrument7 Star6)
	(calibration_target instrument7 GroundStation0)
	(supports instrument8 thermograph2)
	(supports instrument8 image6)
	(supports instrument8 thermograph4)
	(calibration_target instrument8 Star3)
	(calibration_target instrument8 GroundStation0)
	(supports instrument9 thermograph3)
	(calibration_target instrument9 Star6)
	(calibration_target instrument9 GroundStation11)
	(calibration_target instrument9 Star10)
	(calibration_target instrument9 GroundStation2)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(on_board instrument9 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star13)
	(supports instrument10 infrared5)
	(supports instrument10 thermograph2)
	(calibration_target instrument10 GroundStation9)
	(supports instrument11 image6)
	(calibration_target instrument11 GroundStation11)
	(supports instrument12 image6)
	(supports instrument12 thermograph4)
	(calibration_target instrument12 GroundStation2)
	(calibration_target instrument12 GroundStation8)
	(calibration_target instrument12 GroundStation4)
	(calibration_target instrument12 GroundStation9)
	(on_board instrument10 satellite3)
	(on_board instrument11 satellite3)
	(on_board instrument12 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation11)
)
(:goal (and
	(pointing satellite1 Star6)
	(have_image Star12 thermograph2)
	(have_image Star13 image1)
	(have_image Star13 image6)
	(have_image Planet14 thermograph4)
	(have_image Planet14 thermograph3)
	(have_image Planet15 thermograph3)
))

)
