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
	satellite6 - satellite
	instrument9 - instrument
	satellite7 - satellite
	instrument10 - instrument
	thermograph3 - mode
	spectrograph0 - mode
	image2 - mode
	image1 - mode
	GroundStation4 - direction
	Star5 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	Star0 - direction
	GroundStation3 - direction
	Planet6 - direction
	Star7 - direction
	Planet8 - direction
	Star9 - direction
	Planet10 - direction
	Star11 - direction
	Planet12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 thermograph3)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon14)
	(supports instrument1 image1)
	(calibration_target instrument1 Star5)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star11)
	(supports instrument2 thermograph3)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 Star5)
	(supports instrument3 image2)
	(supports instrument3 thermograph3)
	(supports instrument3 image1)
	(calibration_target instrument3 Star5)
	(calibration_target instrument3 Star0)
	(on_board instrument2 satellite2)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star0)
	(supports instrument4 image1)
	(calibration_target instrument4 GroundStation2)
	(on_board instrument4 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet8)
	(supports instrument5 spectrograph0)
	(supports instrument5 image1)
	(supports instrument5 thermograph3)
	(calibration_target instrument5 Star0)
	(supports instrument6 image1)
	(calibration_target instrument6 Star5)
	(calibration_target instrument6 GroundStation1)
	(on_board instrument5 satellite4)
	(on_board instrument6 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation2)
	(supports instrument7 image1)
	(supports instrument7 thermograph3)
	(calibration_target instrument7 GroundStation1)
	(calibration_target instrument7 Star0)
	(supports instrument8 spectrograph0)
	(supports instrument8 image1)
	(supports instrument8 thermograph3)
	(calibration_target instrument8 GroundStation3)
	(on_board instrument7 satellite5)
	(on_board instrument8 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Star7)
	(supports instrument9 image1)
	(supports instrument9 image2)
	(supports instrument9 spectrograph0)
	(calibration_target instrument9 GroundStation3)
	(calibration_target instrument9 GroundStation2)
	(on_board instrument9 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Planet12)
	(supports instrument10 image2)
	(calibration_target instrument10 GroundStation3)
	(calibration_target instrument10 Star0)
	(on_board instrument10 satellite7)
	(power_avail satellite7)
	(pointing satellite7 Planet10)
)
(:goal (and
	(pointing satellite4 Planet6)
	(pointing satellite5 Star0)
	(pointing satellite7 GroundStation1)
	(have_image Planet6 thermograph3)
	(have_image Star7 thermograph3)
	(have_image Planet8 spectrograph0)
	(have_image Star9 image1)
	(have_image Planet10 thermograph3)
	(have_image Star11 thermograph3)
	(have_image Planet12 image1)
	(have_image Phenomenon13 spectrograph0)
	(have_image Phenomenon14 image2)
))

)
