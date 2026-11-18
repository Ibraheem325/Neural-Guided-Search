(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	instrument5 - instrument
	satellite3 - satellite
	instrument6 - instrument
	instrument7 - instrument
	satellite4 - satellite
	instrument8 - instrument
	instrument9 - instrument
	satellite5 - satellite
	instrument10 - instrument
	satellite6 - satellite
	instrument11 - instrument
	thermograph0 - mode
	image2 - mode
	spectrograph1 - mode
	image3 - mode
	Star0 - direction
	GroundStation7 - direction
	GroundStation3 - direction
	Star5 - direction
	GroundStation6 - direction
	Star1 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	GroundStation8 - direction
	Star9 - direction
	Star10 - direction
	Star11 - direction
	Star12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
	Phenomenon17 - direction
	Star18 - direction
	Planet19 - direction
	Planet20 - direction
	Star21 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 GroundStation7)
	(supports instrument1 image3)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 GroundStation2)
	(calibration_target instrument1 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star18)
	(supports instrument2 thermograph0)
	(supports instrument2 image2)
	(calibration_target instrument2 GroundStation2)
	(supports instrument3 spectrograph1)
	(calibration_target instrument3 GroundStation2)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 GroundStation6)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star1)
	(supports instrument4 spectrograph1)
	(supports instrument4 thermograph0)
	(supports instrument4 image3)
	(calibration_target instrument4 GroundStation8)
	(supports instrument5 thermograph0)
	(calibration_target instrument5 GroundStation2)
	(calibration_target instrument5 GroundStation8)
	(calibration_target instrument5 GroundStation3)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation8)
	(supports instrument6 image2)
	(supports instrument6 thermograph0)
	(supports instrument6 image3)
	(calibration_target instrument6 GroundStation7)
	(calibration_target instrument6 GroundStation6)
	(supports instrument7 image2)
	(supports instrument7 spectrograph1)
	(calibration_target instrument7 GroundStation2)
	(calibration_target instrument7 GroundStation3)
	(calibration_target instrument7 GroundStation7)
	(on_board instrument6 satellite3)
	(on_board instrument7 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star11)
	(supports instrument8 image2)
	(calibration_target instrument8 Star5)
	(calibration_target instrument8 GroundStation3)
	(supports instrument9 image3)
	(supports instrument9 thermograph0)
	(calibration_target instrument9 GroundStation2)
	(calibration_target instrument9 Star1)
	(calibration_target instrument9 GroundStation6)
	(on_board instrument8 satellite4)
	(on_board instrument9 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation8)
	(supports instrument10 spectrograph1)
	(supports instrument10 image3)
	(calibration_target instrument10 GroundStation4)
	(on_board instrument10 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Star21)
	(supports instrument11 image3)
	(supports instrument11 thermograph0)
	(supports instrument11 spectrograph1)
	(calibration_target instrument11 GroundStation8)
	(on_board instrument11 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Star11)
)
(:goal (and
	(pointing satellite0 Planet19)
	(pointing satellite2 Star1)
	(pointing satellite5 GroundStation6)
	(pointing satellite6 GroundStation3)
	(have_image Star9 image2)
	(have_image Star10 image2)
	(have_image Star11 image3)
	(have_image Star12 spectrograph1)
	(have_image Phenomenon13 spectrograph1)
	(have_image Phenomenon14 thermograph0)
	(have_image Phenomenon15 thermograph0)
	(have_image Phenomenon16 image2)
	(have_image Phenomenon17 image2)
	(have_image Star18 thermograph0)
	(have_image Planet19 spectrograph1)
	(have_image Planet20 image2)
	(have_image Star21 thermograph0)
))

)
