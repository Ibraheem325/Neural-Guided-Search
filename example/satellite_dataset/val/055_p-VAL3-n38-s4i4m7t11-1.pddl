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
	satellite2 - satellite
	instrument5 - instrument
	instrument6 - instrument
	instrument7 - instrument
	instrument8 - instrument
	satellite3 - satellite
	instrument9 - instrument
	instrument10 - instrument
	instrument11 - instrument
	infrared5 - mode
	thermograph0 - mode
	thermograph2 - mode
	image1 - mode
	thermograph4 - mode
	image6 - mode
	thermograph3 - mode
	Star3 - direction
	Star1 - direction
	Star10 - direction
	GroundStation7 - direction
	Star5 - direction
	GroundStation4 - direction
	GroundStation0 - direction
	GroundStation9 - direction
	GroundStation2 - direction
	GroundStation8 - direction
	Star6 - direction
	Phenomenon11 - direction
	Star12 - direction
	Phenomenon13 - direction
	Planet14 - direction
)
(:init
	(supports instrument0 infrared5)
	(calibration_target instrument0 GroundStation9)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 Star6)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star6)
	(supports instrument2 thermograph0)
	(calibration_target instrument2 GroundStation7)
	(calibration_target instrument2 GroundStation4)
	(calibration_target instrument2 GroundStation8)
	(supports instrument3 thermograph4)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 Star3)
	(calibration_target instrument3 Star1)
	(supports instrument4 infrared5)
	(calibration_target instrument4 Star1)
	(calibration_target instrument4 GroundStation4)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet14)
	(supports instrument5 thermograph4)
	(supports instrument5 thermograph0)
	(calibration_target instrument5 Star10)
	(calibration_target instrument5 Star6)
	(supports instrument6 image6)
	(calibration_target instrument6 GroundStation2)
	(supports instrument7 image1)
	(supports instrument7 thermograph3)
	(calibration_target instrument7 GroundStation7)
	(supports instrument8 infrared5)
	(supports instrument8 image6)
	(calibration_target instrument8 GroundStation4)
	(calibration_target instrument8 Star5)
	(calibration_target instrument8 GroundStation2)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation2)
	(supports instrument9 infrared5)
	(supports instrument9 thermograph4)
	(calibration_target instrument9 GroundStation9)
	(calibration_target instrument9 Star6)
	(calibration_target instrument9 GroundStation0)
	(supports instrument10 infrared5)
	(calibration_target instrument10 GroundStation8)
	(calibration_target instrument10 GroundStation2)
	(calibration_target instrument10 GroundStation9)
	(supports instrument11 thermograph2)
	(supports instrument11 thermograph0)
	(supports instrument11 image1)
	(calibration_target instrument11 Star6)
	(on_board instrument9 satellite3)
	(on_board instrument10 satellite3)
	(on_board instrument11 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star1)
)
(:goal (and
	(pointing satellite1 Planet14)
	(pointing satellite2 Star10)
	(pointing satellite3 Star12)
	(have_image Phenomenon11 thermograph0)
	(have_image Phenomenon11 image1)
	(have_image Star12 image1)
	(have_image Star12 thermograph3)
	(have_image Phenomenon13 thermograph4)
	(have_image Phenomenon13 thermograph0)
	(have_image Planet14 infrared5)
	(have_image Planet14 image1)
))

)
