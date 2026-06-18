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
	instrument6 - instrument
	satellite2 - satellite
	instrument7 - instrument
	instrument8 - instrument
	instrument9 - instrument
	satellite3 - satellite
	instrument10 - instrument
	instrument11 - instrument
	image2 - mode
	image3 - mode
	infrared5 - mode
	spectrograph6 - mode
	image4 - mode
	spectrograph0 - mode
	infrared1 - mode
	GroundStation2 - direction
	GroundStation5 - direction
	GroundStation9 - direction
	GroundStation7 - direction
	Star3 - direction
	Star1 - direction
	GroundStation4 - direction
	GroundStation8 - direction
	GroundStation11 - direction
	GroundStation0 - direction
	GroundStation6 - direction
	Star10 - direction
	Planet12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 infrared5)
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation9)
	(supports instrument1 image4)
	(calibration_target instrument1 GroundStation6)
	(supports instrument2 image2)
	(supports instrument2 infrared1)
	(supports instrument2 infrared5)
	(calibration_target instrument2 GroundStation9)
	(calibration_target instrument2 Star1)
	(calibration_target instrument2 GroundStation5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation11)
	(supports instrument3 spectrograph0)
	(supports instrument3 image3)
	(calibration_target instrument3 Star10)
	(calibration_target instrument3 GroundStation4)
	(calibration_target instrument3 GroundStation8)
	(supports instrument4 spectrograph0)
	(calibration_target instrument4 GroundStation4)
	(calibration_target instrument4 Star1)
	(supports instrument5 spectrograph0)
	(calibration_target instrument5 GroundStation8)
	(calibration_target instrument5 GroundStation7)
	(calibration_target instrument5 GroundStation0)
	(supports instrument6 spectrograph6)
	(calibration_target instrument6 Star1)
	(calibration_target instrument6 GroundStation8)
	(calibration_target instrument6 Star3)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation7)
	(supports instrument7 image2)
	(supports instrument7 infrared1)
	(calibration_target instrument7 GroundStation0)
	(calibration_target instrument7 Star1)
	(supports instrument8 image3)
	(supports instrument8 image2)
	(supports instrument8 infrared1)
	(calibration_target instrument8 Star3)
	(supports instrument9 image2)
	(calibration_target instrument9 Star3)
	(calibration_target instrument9 GroundStation8)
	(calibration_target instrument9 GroundStation0)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(on_board instrument9 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation9)
	(supports instrument10 spectrograph6)
	(supports instrument10 image2)
	(calibration_target instrument10 GroundStation11)
	(calibration_target instrument10 GroundStation8)
	(calibration_target instrument10 GroundStation4)
	(calibration_target instrument10 Star1)
	(supports instrument11 spectrograph0)
	(calibration_target instrument11 Star10)
	(calibration_target instrument11 GroundStation6)
	(calibration_target instrument11 GroundStation0)
	(on_board instrument10 satellite3)
	(on_board instrument11 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation5)
)
(:goal (and
	(pointing satellite1 Star3)
	(pointing satellite3 Phenomenon15)
	(have_image Planet12 spectrograph0)
	(have_image Phenomenon13 infrared5)
	(have_image Phenomenon13 image4)
	(have_image Phenomenon14 image4)
	(have_image Phenomenon15 infrared5)
	(have_image Phenomenon15 spectrograph0)
))

)
