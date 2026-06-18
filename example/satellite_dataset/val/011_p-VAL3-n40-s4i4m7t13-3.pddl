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
	satellite3 - satellite
	instrument8 - instrument
	instrument9 - instrument
	instrument10 - instrument
	instrument11 - instrument
	image3 - mode
	spectrograph6 - mode
	spectrograph0 - mode
	image4 - mode
	infrared1 - mode
	image2 - mode
	infrared5 - mode
	GroundStation12 - direction
	Star3 - direction
	GroundStation11 - direction
	GroundStation8 - direction
	GroundStation0 - direction
	GroundStation9 - direction
	GroundStation7 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	Star10 - direction
	GroundStation5 - direction
	Star1 - direction
	GroundStation6 - direction
	Star13 - direction
	Phenomenon14 - direction
	Star15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 spectrograph6)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 Star10)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 GroundStation11)
	(supports instrument1 infrared5)
	(supports instrument1 infrared1)
	(calibration_target instrument1 GroundStation11)
	(calibration_target instrument1 GroundStation5)
	(calibration_target instrument1 Star1)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 Star10)
	(calibration_target instrument2 GroundStation11)
	(calibration_target instrument2 Star3)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation7)
	(supports instrument3 spectrograph6)
	(supports instrument3 image3)
	(calibration_target instrument3 GroundStation4)
	(calibration_target instrument3 Star10)
	(supports instrument4 infrared1)
	(supports instrument4 spectrograph6)
	(supports instrument4 image3)
	(calibration_target instrument4 Star3)
	(supports instrument5 spectrograph6)
	(calibration_target instrument5 Star3)
	(calibration_target instrument5 GroundStation11)
	(calibration_target instrument5 GroundStation4)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation12)
	(supports instrument6 spectrograph0)
	(supports instrument6 spectrograph6)
	(calibration_target instrument6 GroundStation6)
	(calibration_target instrument6 GroundStation11)
	(calibration_target instrument6 GroundStation0)
	(calibration_target instrument6 GroundStation5)
	(supports instrument7 infrared5)
	(calibration_target instrument7 Star1)
	(calibration_target instrument7 GroundStation8)
	(calibration_target instrument7 Star10)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation8)
	(supports instrument8 image2)
	(calibration_target instrument8 GroundStation6)
	(calibration_target instrument8 GroundStation0)
	(supports instrument9 image4)
	(supports instrument9 infrared1)
	(supports instrument9 spectrograph6)
	(calibration_target instrument9 GroundStation2)
	(calibration_target instrument9 GroundStation7)
	(calibration_target instrument9 GroundStation4)
	(calibration_target instrument9 GroundStation9)
	(supports instrument10 infrared1)
	(supports instrument10 infrared5)
	(calibration_target instrument10 GroundStation5)
	(calibration_target instrument10 Star10)
	(calibration_target instrument10 GroundStation4)
	(supports instrument11 spectrograph6)
	(supports instrument11 infrared1)
	(supports instrument11 image3)
	(calibration_target instrument11 GroundStation6)
	(calibration_target instrument11 Star1)
	(on_board instrument8 satellite3)
	(on_board instrument9 satellite3)
	(on_board instrument10 satellite3)
	(on_board instrument11 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star10)
)
(:goal (and
	(pointing satellite0 Star15)
	(pointing satellite2 Phenomenon16)
	(pointing satellite3 GroundStation8)
	(have_image Star13 image4)
	(have_image Phenomenon14 spectrograph6)
	(have_image Phenomenon14 infrared1)
	(have_image Star15 image2)
	(have_image Star15 spectrograph6)
	(have_image Phenomenon16 image3)
	(have_image Phenomenon16 image4)
))

)
