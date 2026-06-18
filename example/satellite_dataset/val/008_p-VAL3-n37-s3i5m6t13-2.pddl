(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	instrument4 - instrument
	satellite1 - satellite
	instrument5 - instrument
	satellite2 - satellite
	instrument6 - instrument
	instrument7 - instrument
	instrument8 - instrument
	instrument9 - instrument
	instrument10 - instrument
	image4 - mode
	thermograph1 - mode
	spectrograph0 - mode
	infrared2 - mode
	image5 - mode
	infrared3 - mode
	GroundStation0 - direction
	GroundStation2 - direction
	Star12 - direction
	GroundStation8 - direction
	GroundStation3 - direction
	Star5 - direction
	GroundStation4 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation1 - direction
	GroundStation11 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	Planet13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 GroundStation8)
	(supports instrument1 infrared3)
	(supports instrument1 infrared2)
	(calibration_target instrument1 GroundStation8)
	(calibration_target instrument1 GroundStation11)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 GroundStation7)
	(supports instrument2 infrared3)
	(calibration_target instrument2 GroundStation9)
	(supports instrument3 image5)
	(supports instrument3 image4)
	(supports instrument3 infrared3)
	(calibration_target instrument3 GroundStation9)
	(calibration_target instrument3 GroundStation6)
	(supports instrument4 infrared3)
	(calibration_target instrument4 GroundStation11)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(on_board instrument4 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
	(supports instrument5 thermograph1)
	(calibration_target instrument5 GroundStation10)
	(calibration_target instrument5 GroundStation9)
	(calibration_target instrument5 GroundStation11)
	(calibration_target instrument5 GroundStation3)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation9)
	(supports instrument6 infrared2)
	(supports instrument6 infrared3)
	(supports instrument6 image5)
	(calibration_target instrument6 GroundStation1)
	(calibration_target instrument6 GroundStation4)
	(calibration_target instrument6 GroundStation10)
	(calibration_target instrument6 Star5)
	(supports instrument7 thermograph1)
	(supports instrument7 infrared3)
	(supports instrument7 image5)
	(calibration_target instrument7 GroundStation11)
	(supports instrument8 thermograph1)
	(calibration_target instrument8 GroundStation11)
	(calibration_target instrument8 GroundStation10)
	(calibration_target instrument8 GroundStation1)
	(calibration_target instrument8 GroundStation9)
	(supports instrument9 spectrograph0)
	(supports instrument9 infrared3)
	(supports instrument9 infrared2)
	(calibration_target instrument9 GroundStation1)
	(supports instrument10 image5)
	(supports instrument10 thermograph1)
	(supports instrument10 infrared3)
	(calibration_target instrument10 GroundStation7)
	(calibration_target instrument10 GroundStation6)
	(calibration_target instrument10 GroundStation11)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(on_board instrument9 satellite2)
	(on_board instrument10 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet13)
)
(:goal (and
	(pointing satellite2 GroundStation4)
	(have_image Planet13 thermograph1)
	(have_image Planet13 image5)
	(have_image Phenomenon14 image5)
	(have_image Phenomenon14 infrared2)
	(have_image Phenomenon15 image5)
	(have_image Phenomenon15 spectrograph0)
	(have_image Phenomenon16 image5)
	(have_image Phenomenon16 infrared2)
))

)
