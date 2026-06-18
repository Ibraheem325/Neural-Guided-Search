(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	instrument5 - instrument
	instrument6 - instrument
	instrument7 - instrument
	satellite3 - satellite
	instrument8 - instrument
	satellite4 - satellite
	instrument9 - instrument
	instrument10 - instrument
	instrument11 - instrument
	infrared5 - mode
	image4 - mode
	infrared1 - mode
	image3 - mode
	image2 - mode
	spectrograph0 - mode
	spectrograph6 - mode
	GroundStation9 - direction
	GroundStation7 - direction
	GroundStation6 - direction
	Star3 - direction
	GroundStation8 - direction
	GroundStation2 - direction
	Star1 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	GroundStation0 - direction
	Phenomenon10 - direction
	Star11 - direction
	Planet12 - direction
	Phenomenon13 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 image4)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 GroundStation8)
	(supports instrument1 infrared1)
	(supports instrument1 spectrograph6)
	(calibration_target instrument1 GroundStation4)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 GroundStation5)
	(supports instrument2 image4)
	(calibration_target instrument2 GroundStation5)
	(calibration_target instrument2 GroundStation4)
	(calibration_target instrument2 GroundStation2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet12)
	(supports instrument3 infrared5)
	(supports instrument3 image4)
	(supports instrument3 image2)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 GroundStation9)
	(calibration_target instrument3 GroundStation2)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon13)
	(supports instrument4 spectrograph0)
	(calibration_target instrument4 GroundStation2)
	(calibration_target instrument4 GroundStation5)
	(calibration_target instrument4 GroundStation7)
	(supports instrument5 spectrograph0)
	(calibration_target instrument5 GroundStation6)
	(supports instrument6 image3)
	(supports instrument6 infrared1)
	(calibration_target instrument6 GroundStation8)
	(supports instrument7 infrared1)
	(supports instrument7 infrared5)
	(supports instrument7 spectrograph0)
	(calibration_target instrument7 GroundStation8)
	(calibration_target instrument7 Star3)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star11)
	(supports instrument8 infrared1)
	(supports instrument8 image3)
	(calibration_target instrument8 Star1)
	(calibration_target instrument8 GroundStation2)
	(on_board instrument8 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star1)
	(supports instrument9 infrared5)
	(supports instrument9 spectrograph6)
	(supports instrument9 spectrograph0)
	(calibration_target instrument9 Star1)
	(supports instrument10 image3)
	(supports instrument10 image2)
	(supports instrument10 infrared5)
	(calibration_target instrument10 GroundStation5)
	(calibration_target instrument10 GroundStation0)
	(calibration_target instrument10 GroundStation4)
	(supports instrument11 image4)
	(calibration_target instrument11 GroundStation0)
	(on_board instrument9 satellite4)
	(on_board instrument10 satellite4)
	(on_board instrument11 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation2)
)
(:goal (and
	(pointing satellite0 GroundStation4)
	(pointing satellite1 GroundStation8)
	(pointing satellite3 GroundStation9)
	(pointing satellite4 GroundStation8)
	(have_image Phenomenon10 image4)
	(have_image Phenomenon10 image3)
	(have_image Star11 image2)
	(have_image Star11 infrared1)
	(have_image Planet12 spectrograph6)
	(have_image Phenomenon13 infrared1)
))

)
