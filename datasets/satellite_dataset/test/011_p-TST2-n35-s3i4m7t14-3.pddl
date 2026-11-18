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
	instrument5 - instrument
	satellite2 - satellite
	instrument6 - instrument
	instrument7 - instrument
	instrument8 - instrument
	instrument9 - instrument
	image4 - mode
	infrared5 - mode
	image2 - mode
	infrared1 - mode
	image3 - mode
	spectrograph6 - mode
	spectrograph0 - mode
	GroundStation6 - direction
	GroundStation0 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	GroundStation9 - direction
	Star3 - direction
	GroundStation12 - direction
	Star13 - direction
	GroundStation8 - direction
	GroundStation5 - direction
	GroundStation11 - direction
	Star1 - direction
	GroundStation7 - direction
	Star10 - direction
	Phenomenon14 - direction
	Star15 - direction
	Phenomenon16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 image2)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 GroundStation9)
	(supports instrument1 image2)
	(supports instrument1 infrared5)
	(calibration_target instrument1 Star13)
	(calibration_target instrument1 GroundStation5)
	(calibration_target instrument1 GroundStation7)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon14)
	(supports instrument2 image2)
	(supports instrument2 spectrograph0)
	(supports instrument2 image4)
	(calibration_target instrument2 Star13)
	(calibration_target instrument2 GroundStation5)
	(supports instrument3 image4)
	(supports instrument3 infrared5)
	(calibration_target instrument3 GroundStation5)
	(calibration_target instrument3 GroundStation2)
	(calibration_target instrument3 GroundStation7)
	(calibration_target instrument3 Star10)
	(supports instrument4 infrared1)
	(supports instrument4 spectrograph0)
	(calibration_target instrument4 GroundStation11)
	(calibration_target instrument4 GroundStation4)
	(calibration_target instrument4 GroundStation9)
	(supports instrument5 spectrograph0)
	(supports instrument5 spectrograph6)
	(calibration_target instrument5 Star3)
	(calibration_target instrument5 Star1)
	(calibration_target instrument5 GroundStation9)
	(calibration_target instrument5 GroundStation8)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation6)
	(supports instrument6 image3)
	(calibration_target instrument6 GroundStation12)
	(supports instrument7 infrared1)
	(supports instrument7 spectrograph6)
	(supports instrument7 infrared5)
	(calibration_target instrument7 GroundStation5)
	(calibration_target instrument7 GroundStation8)
	(calibration_target instrument7 Star13)
	(calibration_target instrument7 GroundStation7)
	(supports instrument8 image3)
	(supports instrument8 infrared1)
	(supports instrument8 image2)
	(calibration_target instrument8 Star1)
	(calibration_target instrument8 GroundStation11)
	(supports instrument9 spectrograph0)
	(supports instrument9 image2)
	(calibration_target instrument9 Star10)
	(calibration_target instrument9 GroundStation7)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(on_board instrument9 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation11)
)
(:goal (and
	(pointing satellite2 GroundStation12)
	(have_image Phenomenon14 image4)
	(have_image Star15 infrared5)
	(have_image Star15 image2)
	(have_image Phenomenon16 image3)
	(have_image Planet17 spectrograph0)
))

)
