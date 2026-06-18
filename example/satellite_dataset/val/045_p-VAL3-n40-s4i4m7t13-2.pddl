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
	satellite2 - satellite
	instrument5 - instrument
	instrument6 - instrument
	instrument7 - instrument
	instrument8 - instrument
	satellite3 - satellite
	instrument9 - instrument
	instrument10 - instrument
	spectrograph6 - mode
	image5 - mode
	infrared3 - mode
	spectrograph0 - mode
	infrared2 - mode
	image4 - mode
	thermograph1 - mode
	GroundStation1 - direction
	Star7 - direction
	GroundStation9 - direction
	Star11 - direction
	GroundStation6 - direction
	GroundStation10 - direction
	Star0 - direction
	Star2 - direction
	GroundStation12 - direction
	Star5 - direction
	GroundStation4 - direction
	GroundStation8 - direction
	GroundStation3 - direction
	Planet13 - direction
	Phenomenon14 - direction
	Planet15 - direction
	Planet16 - direction
)
(:init
	(supports instrument0 image5)
	(supports instrument0 image4)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 GroundStation8)
	(supports instrument1 image5)
	(supports instrument1 thermograph1)
	(supports instrument1 infrared2)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 Star0)
	(calibration_target instrument1 GroundStation10)
	(supports instrument2 infrared3)
	(supports instrument2 image4)
	(supports instrument2 spectrograph6)
	(calibration_target instrument2 GroundStation8)
	(calibration_target instrument2 Star2)
	(calibration_target instrument2 GroundStation9)
	(supports instrument3 image4)
	(supports instrument3 spectrograph0)
	(supports instrument3 spectrograph6)
	(calibration_target instrument3 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation6)
	(supports instrument4 infrared2)
	(calibration_target instrument4 GroundStation10)
	(calibration_target instrument4 GroundStation8)
	(calibration_target instrument4 Star0)
	(calibration_target instrument4 Star11)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation8)
	(supports instrument5 image5)
	(supports instrument5 spectrograph0)
	(supports instrument5 image4)
	(calibration_target instrument5 GroundStation4)
	(calibration_target instrument5 GroundStation6)
	(calibration_target instrument5 GroundStation10)
	(calibration_target instrument5 GroundStation3)
	(supports instrument6 spectrograph6)
	(supports instrument6 spectrograph0)
	(supports instrument6 infrared2)
	(calibration_target instrument6 Star0)
	(supports instrument7 spectrograph6)
	(calibration_target instrument7 Star0)
	(calibration_target instrument7 GroundStation10)
	(calibration_target instrument7 GroundStation4)
	(calibration_target instrument7 GroundStation8)
	(supports instrument8 thermograph1)
	(supports instrument8 spectrograph0)
	(supports instrument8 image5)
	(calibration_target instrument8 GroundStation4)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet13)
	(supports instrument9 thermograph1)
	(supports instrument9 spectrograph0)
	(supports instrument9 infrared3)
	(calibration_target instrument9 GroundStation4)
	(calibration_target instrument9 GroundStation12)
	(calibration_target instrument9 Star2)
	(supports instrument10 thermograph1)
	(supports instrument10 spectrograph6)
	(supports instrument10 spectrograph0)
	(calibration_target instrument10 GroundStation3)
	(calibration_target instrument10 GroundStation8)
	(calibration_target instrument10 GroundStation4)
	(calibration_target instrument10 Star5)
	(on_board instrument9 satellite3)
	(on_board instrument10 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet13)
)
(:goal (and
	(pointing satellite0 GroundStation10)
	(pointing satellite2 GroundStation6)
	(have_image Planet13 spectrograph6)
	(have_image Phenomenon14 thermograph1)
	(have_image Phenomenon14 spectrograph6)
	(have_image Planet15 infrared2)
	(have_image Planet16 thermograph1)
	(have_image Planet16 image4)
))

)
