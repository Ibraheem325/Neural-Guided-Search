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
	instrument7 - instrument
	satellite2 - satellite
	instrument8 - instrument
	instrument9 - instrument
	instrument10 - instrument
	instrument11 - instrument
	instrument12 - instrument
	image6 - mode
	thermograph4 - mode
	thermograph0 - mode
	infrared5 - mode
	image1 - mode
	thermograph3 - mode
	thermograph2 - mode
	GroundStation0 - direction
	Star5 - direction
	GroundStation7 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	Star3 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	Star1 - direction
	Star6 - direction
	Phenomenon10 - direction
	Phenomenon11 - direction
	Planet12 - direction
	Phenomenon13 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared5)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 GroundStation7)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 GroundStation8)
	(calibration_target instrument1 GroundStation2)
	(calibration_target instrument1 Star5)
	(supports instrument2 image6)
	(supports instrument2 thermograph3)
	(supports instrument2 image1)
	(calibration_target instrument2 GroundStation7)
	(calibration_target instrument2 Star6)
	(supports instrument3 thermograph2)
	(calibration_target instrument3 GroundStation7)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation7)
	(supports instrument4 thermograph4)
	(supports instrument4 image6)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 GroundStation7)
	(calibration_target instrument4 Star6)
	(calibration_target instrument4 GroundStation2)
	(supports instrument5 thermograph4)
	(calibration_target instrument5 Star6)
	(calibration_target instrument5 GroundStation9)
	(calibration_target instrument5 Star5)
	(supports instrument6 thermograph2)
	(supports instrument6 thermograph4)
	(calibration_target instrument6 Star3)
	(calibration_target instrument6 Star1)
	(supports instrument7 image6)
	(calibration_target instrument7 Star1)
	(calibration_target instrument7 GroundStation9)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(on_board instrument7 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon11)
	(supports instrument8 thermograph2)
	(supports instrument8 thermograph4)
	(calibration_target instrument8 GroundStation2)
	(calibration_target instrument8 GroundStation7)
	(supports instrument9 image1)
	(calibration_target instrument9 GroundStation4)
	(supports instrument10 thermograph0)
	(supports instrument10 thermograph3)
	(calibration_target instrument10 Star3)
	(supports instrument11 image6)
	(supports instrument11 image1)
	(calibration_target instrument11 GroundStation9)
	(calibration_target instrument11 GroundStation8)
	(calibration_target instrument11 Star3)
	(supports instrument12 thermograph2)
	(supports instrument12 image1)
	(calibration_target instrument12 Star6)
	(calibration_target instrument12 Star1)
	(on_board instrument8 satellite2)
	(on_board instrument9 satellite2)
	(on_board instrument10 satellite2)
	(on_board instrument11 satellite2)
	(on_board instrument12 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation4)
)
(:goal (and
	(pointing satellite0 Star6)
	(pointing satellite2 GroundStation2)
	(have_image Phenomenon10 thermograph2)
	(have_image Phenomenon10 image1)
	(have_image Phenomenon11 thermograph0)
	(have_image Phenomenon11 thermograph3)
	(have_image Planet12 thermograph0)
	(have_image Planet12 thermograph3)
	(have_image Phenomenon13 image1)
	(have_image Phenomenon13 thermograph4)
))

)
