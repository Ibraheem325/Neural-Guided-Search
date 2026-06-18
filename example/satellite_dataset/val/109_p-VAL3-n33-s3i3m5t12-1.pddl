(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	satellite2 - satellite
	instrument6 - instrument
	instrument7 - instrument
	instrument8 - instrument
	thermograph2 - mode
	thermograph0 - mode
	image1 - mode
	thermograph4 - mode
	thermograph3 - mode
	Star3 - direction
	Star4 - direction
	Star8 - direction
	GroundStation7 - direction
	GroundStation11 - direction
	GroundStation5 - direction
	Star1 - direction
	Star0 - direction
	GroundStation2 - direction
	GroundStation6 - direction
	Star9 - direction
	GroundStation10 - direction
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
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
	(supports instrument3 image1)
	(supports instrument3 thermograph3)
	(calibration_target instrument3 GroundStation7)
	(calibration_target instrument3 Star8)
	(supports instrument4 thermograph2)
	(calibration_target instrument4 Star1)
	(supports instrument5 thermograph0)
	(supports instrument5 thermograph3)
	(calibration_target instrument5 GroundStation11)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star1)
	(supports instrument6 thermograph2)
	(supports instrument6 thermograph4)
	(calibration_target instrument6 GroundStation5)
	(calibration_target instrument6 Star1)
	(calibration_target instrument6 Star9)
	(supports instrument7 thermograph2)
	(supports instrument7 thermograph3)
	(calibration_target instrument7 GroundStation2)
	(calibration_target instrument7 GroundStation6)
	(calibration_target instrument7 Star0)
	(calibration_target instrument7 Star1)
	(supports instrument8 image1)
	(supports instrument8 thermograph4)
	(supports instrument8 thermograph2)
	(calibration_target instrument8 GroundStation10)
	(calibration_target instrument8 Star9)
	(calibration_target instrument8 GroundStation6)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star9)
)
(:goal (and
	(pointing satellite1 GroundStation7)
	(have_image Planet12 thermograph0)
	(have_image Planet13 image1)
	(have_image Star14 thermograph2)
	(have_image Star15 thermograph4)
))

)
