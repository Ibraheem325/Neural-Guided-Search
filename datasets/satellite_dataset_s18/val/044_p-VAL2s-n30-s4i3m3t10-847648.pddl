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
	instrument5 - instrument
	satellite3 - satellite
	instrument6 - instrument
	instrument7 - instrument
	instrument8 - instrument
	image1 - mode
	thermograph0 - mode
	image2 - mode
	GroundStation1 - direction
	GroundStation4 - direction
	Star3 - direction
	GroundStation8 - direction
	GroundStation6 - direction
	Star5 - direction
	Star7 - direction
	GroundStation2 - direction
	GroundStation9 - direction
	GroundStation0 - direction
	Star10 - direction
	Phenomenon11 - direction
	Planet12 - direction
	Phenomenon13 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 GroundStation2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
	(supports instrument1 image1)
	(supports instrument1 thermograph0)
	(supports instrument1 image2)
	(calibration_target instrument1 GroundStation0)
	(calibration_target instrument1 GroundStation8)
	(calibration_target instrument1 Star3)
	(supports instrument2 image2)
	(supports instrument2 image1)
	(calibration_target instrument2 GroundStation0)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon13)
	(supports instrument3 image1)
	(supports instrument3 image2)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 GroundStation2)
	(supports instrument4 image1)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 Star7)
	(calibration_target instrument4 Star3)
	(supports instrument5 image2)
	(calibration_target instrument5 GroundStation2)
	(calibration_target instrument5 GroundStation6)
	(calibration_target instrument5 GroundStation8)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star7)
	(supports instrument6 image1)
	(supports instrument6 thermograph0)
	(calibration_target instrument6 Star5)
	(supports instrument7 image1)
	(supports instrument7 image2)
	(supports instrument7 thermograph0)
	(calibration_target instrument7 Star7)
	(supports instrument8 thermograph0)
	(supports instrument8 image1)
	(supports instrument8 image2)
	(calibration_target instrument8 GroundStation0)
	(calibration_target instrument8 GroundStation9)
	(calibration_target instrument8 GroundStation2)
	(on_board instrument6 satellite3)
	(on_board instrument7 satellite3)
	(on_board instrument8 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation2)
)
(:goal (and
	(pointing satellite2 GroundStation6)
	(have_image Star10 image2)
	(have_image Phenomenon11 thermograph0)
	(have_image Planet12 image1)
	(have_image Phenomenon13 image1)
))

)
