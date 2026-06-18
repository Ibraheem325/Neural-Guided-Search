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
	instrument9 - instrument
	spectrograph0 - mode
	infrared2 - mode
	image5 - mode
	image4 - mode
	infrared3 - mode
	thermograph1 - mode
	spectrograph6 - mode
	Star7 - direction
	GroundStation9 - direction
	GroundStation1 - direction
	Star11 - direction
	GroundStation10 - direction
	GroundStation8 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation4 - direction
	Star2 - direction
	GroundStation3 - direction
	Star0 - direction
	Planet12 - direction
	Planet13 - direction
	Star14 - direction
	Star15 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 Star11)
	(calibration_target instrument0 GroundStation3)
	(supports instrument1 spectrograph6)
	(calibration_target instrument1 GroundStation8)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 GroundStation6)
	(calibration_target instrument1 Star11)
	(supports instrument2 spectrograph0)
	(supports instrument2 image5)
	(supports instrument2 image4)
	(calibration_target instrument2 GroundStation9)
	(calibration_target instrument2 GroundStation3)
	(supports instrument3 image5)
	(calibration_target instrument3 Star2)
	(calibration_target instrument3 Star5)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 GroundStation10)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star7)
	(supports instrument4 infrared3)
	(supports instrument4 image4)
	(calibration_target instrument4 GroundStation8)
	(calibration_target instrument4 GroundStation1)
	(supports instrument5 spectrograph6)
	(supports instrument5 image4)
	(calibration_target instrument5 GroundStation4)
	(calibration_target instrument5 GroundStation8)
	(calibration_target instrument5 GroundStation6)
	(supports instrument6 infrared2)
	(supports instrument6 infrared3)
	(supports instrument6 thermograph1)
	(calibration_target instrument6 GroundStation10)
	(calibration_target instrument6 Star5)
	(calibration_target instrument6 GroundStation4)
	(calibration_target instrument6 Star11)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation1)
	(supports instrument7 image4)
	(calibration_target instrument7 GroundStation4)
	(calibration_target instrument7 Star5)
	(calibration_target instrument7 Star0)
	(calibration_target instrument7 GroundStation8)
	(supports instrument8 image5)
	(supports instrument8 infrared3)
	(supports instrument8 infrared2)
	(calibration_target instrument8 GroundStation3)
	(calibration_target instrument8 Star2)
	(calibration_target instrument8 GroundStation4)
	(calibration_target instrument8 GroundStation6)
	(supports instrument9 thermograph1)
	(supports instrument9 infrared3)
	(supports instrument9 image4)
	(calibration_target instrument9 Star0)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(on_board instrument9 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star0)
)
(:goal (and
	(pointing satellite0 GroundStation9)
	(have_image Planet12 infrared2)
	(have_image Planet13 thermograph1)
	(have_image Star14 spectrograph6)
	(have_image Star15 spectrograph0)
))

)
