(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	satellite1 - satellite
	instrument4 - instrument
	instrument5 - instrument
	instrument6 - instrument
	satellite2 - satellite
	instrument7 - instrument
	instrument8 - instrument
	instrument9 - instrument
	instrument10 - instrument
	thermograph0 - mode
	thermograph4 - mode
	image1 - mode
	thermograph3 - mode
	thermograph2 - mode
	Star8 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation10 - direction
	GroundStation2 - direction
	GroundStation7 - direction
	Star0 - direction
	GroundStation11 - direction
	Star1 - direction
	Star9 - direction
	Star4 - direction
	Star3 - direction
	Planet12 - direction
	Planet13 - direction
	Star14 - direction
	Star15 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph4)
	(supports instrument0 image1)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 GroundStation11)
	(supports instrument1 thermograph3)
	(supports instrument1 image1)
	(calibration_target instrument1 GroundStation5)
	(calibration_target instrument1 GroundStation6)
	(calibration_target instrument1 GroundStation11)
	(calibration_target instrument1 Star4)
	(supports instrument2 image1)
	(calibration_target instrument2 GroundStation6)
	(calibration_target instrument2 GroundStation10)
	(supports instrument3 thermograph2)
	(supports instrument3 thermograph4)
	(calibration_target instrument3 Star3)
	(calibration_target instrument3 GroundStation6)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 Star1)
	(supports instrument5 image1)
	(supports instrument5 thermograph4)
	(calibration_target instrument5 Star4)
	(supports instrument6 thermograph2)
	(supports instrument6 thermograph4)
	(calibration_target instrument6 GroundStation11)
	(calibration_target instrument6 GroundStation2)
	(calibration_target instrument6 Star1)
	(calibration_target instrument6 GroundStation10)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star15)
	(supports instrument7 thermograph2)
	(supports instrument7 thermograph3)
	(calibration_target instrument7 Star0)
	(calibration_target instrument7 Star1)
	(supports instrument8 thermograph2)
	(calibration_target instrument8 GroundStation7)
	(calibration_target instrument8 Star3)
	(calibration_target instrument8 Star0)
	(supports instrument9 thermograph0)
	(supports instrument9 image1)
	(supports instrument9 thermograph3)
	(calibration_target instrument9 GroundStation11)
	(calibration_target instrument9 Star0)
	(supports instrument10 thermograph3)
	(calibration_target instrument10 Star3)
	(calibration_target instrument10 Star4)
	(calibration_target instrument10 Star9)
	(calibration_target instrument10 Star1)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(on_board instrument9 satellite2)
	(on_board instrument10 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet13)
)
(:goal (and
	(pointing satellite1 Star8)
	(have_image Planet12 thermograph0)
	(have_image Planet13 image1)
	(have_image Star14 thermograph2)
	(have_image Star15 thermograph4)
))

)
