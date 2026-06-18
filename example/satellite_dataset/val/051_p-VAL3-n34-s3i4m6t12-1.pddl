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
	satellite2 - satellite
	instrument6 - instrument
	instrument7 - instrument
	instrument8 - instrument
	thermograph0 - mode
	thermograph2 - mode
	infrared5 - mode
	thermograph4 - mode
	thermograph3 - mode
	image1 - mode
	GroundStation6 - direction
	Star3 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation7 - direction
	GroundStation11 - direction
	GroundStation10 - direction
	GroundStation4 - direction
	Star0 - direction
	GroundStation9 - direction
	Star8 - direction
	GroundStation5 - direction
	Phenomenon12 - direction
	Star13 - direction
	Star14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 infrared5)
	(supports instrument0 image1)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 GroundStation5)
	(supports instrument1 thermograph0)
	(supports instrument1 thermograph3)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 GroundStation1)
	(calibration_target instrument1 Star8)
	(supports instrument2 image1)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 Star3)
	(supports instrument3 image1)
	(supports instrument3 thermograph3)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 GroundStation5)
	(calibration_target instrument3 GroundStation7)
	(calibration_target instrument3 GroundStation11)
	(calibration_target instrument3 GroundStation1)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon12)
	(supports instrument4 thermograph0)
	(supports instrument4 infrared5)
	(supports instrument4 thermograph3)
	(calibration_target instrument4 GroundStation9)
	(calibration_target instrument4 GroundStation4)
	(calibration_target instrument4 GroundStation7)
	(calibration_target instrument4 GroundStation2)
	(supports instrument5 image1)
	(supports instrument5 thermograph4)
	(supports instrument5 thermograph3)
	(calibration_target instrument5 GroundStation5)
	(calibration_target instrument5 GroundStation9)
	(calibration_target instrument5 Star8)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation2)
	(supports instrument6 thermograph0)
	(calibration_target instrument6 GroundStation4)
	(calibration_target instrument6 GroundStation10)
	(calibration_target instrument6 GroundStation11)
	(calibration_target instrument6 GroundStation9)
	(supports instrument7 image1)
	(supports instrument7 thermograph2)
	(calibration_target instrument7 Star0)
	(supports instrument8 thermograph2)
	(supports instrument8 thermograph4)
	(supports instrument8 infrared5)
	(calibration_target instrument8 GroundStation5)
	(calibration_target instrument8 Star8)
	(calibration_target instrument8 GroundStation9)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star8)
)
(:goal (and
	(pointing satellite0 Star14)
	(pointing satellite1 GroundStation10)
	(pointing satellite2 Star13)
	(have_image Phenomenon12 thermograph0)
	(have_image Star13 thermograph2)
	(have_image Star13 infrared5)
	(have_image Star14 infrared5)
	(have_image Planet15 thermograph2)
	(have_image Planet15 thermograph0)
))

)
