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
	image5 - mode
	spectrograph6 - mode
	infrared2 - mode
	spectrograph0 - mode
	thermograph1 - mode
	image4 - mode
	infrared3 - mode
	GroundStation3 - direction
	Star2 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star7 - direction
	Star0 - direction
	GroundStation4 - direction
	GroundStation8 - direction
	Star5 - direction
	GroundStation1 - direction
	GroundStation6 - direction
	Star11 - direction
	Star12 - direction
	Star13 - direction
	Phenomenon14 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared3)
	(supports instrument0 image5)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 Star7)
	(supports instrument1 infrared2)
	(supports instrument1 spectrograph6)
	(calibration_target instrument1 Star2)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 Star2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
	(supports instrument3 spectrograph6)
	(supports instrument3 infrared3)
	(calibration_target instrument3 GroundStation4)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 Star2)
	(supports instrument4 spectrograph6)
	(supports instrument4 thermograph1)
	(supports instrument4 infrared2)
	(calibration_target instrument4 GroundStation10)
	(calibration_target instrument4 Star7)
	(calibration_target instrument4 GroundStation8)
	(supports instrument5 thermograph1)
	(supports instrument5 infrared2)
	(supports instrument5 spectrograph0)
	(calibration_target instrument5 GroundStation9)
	(calibration_target instrument5 Star5)
	(supports instrument6 infrared2)
	(calibration_target instrument6 GroundStation10)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation9)
	(supports instrument7 spectrograph6)
	(supports instrument7 image4)
	(supports instrument7 infrared2)
	(calibration_target instrument7 Star5)
	(calibration_target instrument7 GroundStation8)
	(calibration_target instrument7 Star7)
	(supports instrument8 image4)
	(supports instrument8 image5)
	(calibration_target instrument8 GroundStation6)
	(calibration_target instrument8 GroundStation4)
	(calibration_target instrument8 Star0)
	(supports instrument9 thermograph1)
	(supports instrument9 image4)
	(supports instrument9 infrared2)
	(calibration_target instrument9 Star5)
	(calibration_target instrument9 GroundStation1)
	(calibration_target instrument9 GroundStation8)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(on_board instrument9 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star0)
	(supports instrument10 infrared3)
	(calibration_target instrument10 GroundStation6)
	(calibration_target instrument10 GroundStation1)
	(calibration_target instrument10 Star5)
	(on_board instrument10 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star5)
)
(:goal (and
	(pointing satellite0 Star5)
	(pointing satellite1 Star7)
	(have_image Star11 spectrograph6)
	(have_image Star11 infrared3)
	(have_image Star12 image5)
	(have_image Star13 spectrograph0)
	(have_image Phenomenon14 image5)
	(have_image Phenomenon14 thermograph1)
))

)
