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
	satellite2 - satellite
	instrument7 - instrument
	instrument8 - instrument
	satellite3 - satellite
	instrument9 - instrument
	instrument10 - instrument
	image3 - mode
	infrared5 - mode
	image2 - mode
	spectrograph6 - mode
	infrared1 - mode
	spectrograph0 - mode
	image4 - mode
	GroundStation0 - direction
	GroundStation2 - direction
	GroundStation8 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	Star10 - direction
	Star1 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	GroundStation9 - direction
	Star3 - direction
	Phenomenon11 - direction
	Planet12 - direction
	Planet13 - direction
	Planet14 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared5)
	(supports instrument0 spectrograph6)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 GroundStation9)
	(supports instrument1 infrared5)
	(supports instrument1 image2)
	(calibration_target instrument1 GroundStation8)
	(calibration_target instrument1 GroundStation4)
	(supports instrument2 image4)
	(supports instrument2 spectrograph0)
	(supports instrument2 infrared5)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 GroundStation0)
	(supports instrument3 infrared5)
	(supports instrument3 spectrograph0)
	(supports instrument3 spectrograph6)
	(calibration_target instrument3 GroundStation9)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 Star3)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet14)
	(supports instrument4 spectrograph0)
	(supports instrument4 image4)
	(supports instrument4 spectrograph6)
	(calibration_target instrument4 GroundStation9)
	(calibration_target instrument4 GroundStation5)
	(supports instrument5 image3)
	(calibration_target instrument5 GroundStation4)
	(calibration_target instrument5 GroundStation6)
	(supports instrument6 image3)
	(supports instrument6 spectrograph6)
	(calibration_target instrument6 GroundStation7)
	(calibration_target instrument6 GroundStation5)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet12)
	(supports instrument7 spectrograph0)
	(supports instrument7 infrared1)
	(supports instrument7 image4)
	(calibration_target instrument7 GroundStation7)
	(supports instrument8 spectrograph6)
	(supports instrument8 image2)
	(supports instrument8 spectrograph0)
	(calibration_target instrument8 Star3)
	(calibration_target instrument8 Star1)
	(calibration_target instrument8 Star10)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation5)
	(supports instrument9 image2)
	(supports instrument9 infrared5)
	(calibration_target instrument9 GroundStation5)
	(calibration_target instrument9 GroundStation4)
	(supports instrument10 image2)
	(supports instrument10 spectrograph0)
	(calibration_target instrument10 Star3)
	(calibration_target instrument10 GroundStation9)
	(on_board instrument9 satellite3)
	(on_board instrument10 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation0)
)
(:goal (and
	(pointing satellite1 GroundStation7)
	(pointing satellite2 GroundStation4)
	(have_image Phenomenon11 spectrograph0)
	(have_image Planet12 infrared5)
	(have_image Planet13 image2)
	(have_image Planet13 image3)
	(have_image Planet14 image4)
))

)
