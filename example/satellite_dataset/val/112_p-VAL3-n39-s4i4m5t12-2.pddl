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
	satellite3 - satellite
	instrument9 - instrument
	instrument10 - instrument
	instrument11 - instrument
	image4 - mode
	infrared2 - mode
	spectrograph0 - mode
	infrared3 - mode
	thermograph1 - mode
	Star11 - direction
	GroundStation10 - direction
	GroundStation3 - direction
	GroundStation8 - direction
	GroundStation6 - direction
	Star2 - direction
	Star9 - direction
	GroundStation1 - direction
	Star5 - direction
	Star4 - direction
	Star7 - direction
	Star0 - direction
	Star12 - direction
	Star13 - direction
	Planet14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation6)
	(supports instrument1 infrared2)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 Star7)
	(supports instrument2 spectrograph0)
	(supports instrument2 infrared2)
	(supports instrument2 thermograph1)
	(calibration_target instrument2 GroundStation8)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation3)
	(supports instrument3 infrared2)
	(supports instrument3 thermograph1)
	(supports instrument3 infrared3)
	(calibration_target instrument3 GroundStation3)
	(calibration_target instrument3 GroundStation6)
	(supports instrument4 spectrograph0)
	(supports instrument4 infrared2)
	(supports instrument4 thermograph1)
	(calibration_target instrument4 Star5)
	(calibration_target instrument4 GroundStation8)
	(supports instrument5 infrared2)
	(calibration_target instrument5 Star9)
	(calibration_target instrument5 GroundStation1)
	(calibration_target instrument5 GroundStation8)
	(calibration_target instrument5 Star5)
	(supports instrument6 spectrograph0)
	(calibration_target instrument6 GroundStation8)
	(calibration_target instrument6 Star2)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation6)
	(supports instrument7 thermograph1)
	(supports instrument7 infrared2)
	(supports instrument7 spectrograph0)
	(calibration_target instrument7 Star5)
	(supports instrument8 spectrograph0)
	(supports instrument8 infrared3)
	(supports instrument8 thermograph1)
	(calibration_target instrument8 GroundStation6)
	(calibration_target instrument8 Star9)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation10)
	(supports instrument9 infrared2)
	(calibration_target instrument9 Star5)
	(calibration_target instrument9 Star9)
	(calibration_target instrument9 Star0)
	(calibration_target instrument9 Star2)
	(supports instrument10 thermograph1)
	(supports instrument10 spectrograph0)
	(supports instrument10 infrared2)
	(calibration_target instrument10 Star7)
	(calibration_target instrument10 Star4)
	(calibration_target instrument10 Star5)
	(calibration_target instrument10 GroundStation1)
	(supports instrument11 infrared3)
	(supports instrument11 spectrograph0)
	(supports instrument11 infrared2)
	(supports instrument11 image4)
	(calibration_target instrument11 Star0)
	(on_board instrument9 satellite3)
	(on_board instrument10 satellite3)
	(on_board instrument11 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star0)
)
(:goal (and
	(pointing satellite0 GroundStation10)
	(pointing satellite2 GroundStation3)
	(have_image Star12 image4)
	(have_image Star13 infrared3)
	(have_image Planet14 spectrograph0)
	(have_image Planet15 thermograph1)
))

)
