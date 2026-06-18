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
	instrument6 - instrument
	satellite2 - satellite
	instrument7 - instrument
	instrument8 - instrument
	instrument9 - instrument
	infrared2 - mode
	thermograph1 - mode
	spectrograph0 - mode
	image4 - mode
	spectrograph6 - mode
	image5 - mode
	infrared3 - mode
	Star2 - direction
	Star7 - direction
	GroundStation6 - direction
	Star5 - direction
	Star0 - direction
	GroundStation8 - direction
	GroundStation4 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	GroundStation9 - direction
	Phenomenon10 - direction
	Planet11 - direction
	Star12 - direction
	Phenomenon13 - direction
)
(:init
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 Star7)
	(supports instrument1 image4)
	(calibration_target instrument1 GroundStation8)
	(calibration_target instrument1 GroundStation6)
	(calibration_target instrument1 Star7)
	(supports instrument2 thermograph1)
	(supports instrument2 spectrograph6)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 GroundStation4)
	(calibration_target instrument2 GroundStation1)
	(supports instrument3 infrared3)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 Star7)
	(supports instrument4 infrared2)
	(supports instrument4 image4)
	(supports instrument4 thermograph1)
	(calibration_target instrument4 Star5)
	(calibration_target instrument4 GroundStation1)
	(calibration_target instrument4 GroundStation6)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(on_board instrument4 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation9)
	(supports instrument5 thermograph1)
	(supports instrument5 infrared3)
	(calibration_target instrument5 Star0)
	(calibration_target instrument5 GroundStation9)
	(calibration_target instrument5 GroundStation1)
	(supports instrument6 spectrograph0)
	(supports instrument6 image4)
	(supports instrument6 thermograph1)
	(calibration_target instrument6 Star5)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet11)
	(supports instrument7 image4)
	(supports instrument7 spectrograph0)
	(supports instrument7 infrared2)
	(calibration_target instrument7 Star0)
	(calibration_target instrument7 GroundStation1)
	(calibration_target instrument7 GroundStation8)
	(supports instrument8 thermograph1)
	(supports instrument8 image5)
	(calibration_target instrument8 GroundStation4)
	(calibration_target instrument8 GroundStation1)
	(calibration_target instrument8 GroundStation8)
	(supports instrument9 thermograph1)
	(supports instrument9 infrared3)
	(supports instrument9 image4)
	(calibration_target instrument9 GroundStation9)
	(calibration_target instrument9 GroundStation3)
	(calibration_target instrument9 GroundStation1)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(on_board instrument9 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon13)
)
(:goal (and
	(pointing satellite1 Star7)
	(have_image Phenomenon10 spectrograph0)
	(have_image Phenomenon10 thermograph1)
	(have_image Planet11 image4)
	(have_image Planet11 spectrograph6)
	(have_image Star12 infrared3)
	(have_image Phenomenon13 image4)
	(have_image Phenomenon13 spectrograph6)
))

)
