(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	satellite3 - satellite
	instrument6 - instrument
	instrument7 - instrument
	instrument8 - instrument
	satellite4 - satellite
	instrument9 - instrument
	instrument10 - instrument
	thermograph5 - mode
	thermograph1 - mode
	image3 - mode
	spectrograph6 - mode
	infrared4 - mode
	thermograph2 - mode
	infrared0 - mode
	GroundStation7 - direction
	Star4 - direction
	GroundStation6 - direction
	Star8 - direction
	Star0 - direction
	Star5 - direction
	GroundStation3 - direction
	GroundStation1 - direction
	Star2 - direction
	Star9 - direction
	Star11 - direction
	Star12 - direction
	GroundStation10 - direction
	Planet13 - direction
	Star14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star12)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 Star4)
	(supports instrument1 infrared0)
	(supports instrument1 thermograph1)
	(calibration_target instrument1 Star8)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 Star5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
	(supports instrument2 thermograph5)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 Star5)
	(calibration_target instrument2 Star2)
	(calibration_target instrument2 GroundStation6)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation10)
	(supports instrument3 infrared4)
	(calibration_target instrument3 Star2)
	(calibration_target instrument3 Star12)
	(calibration_target instrument3 Star8)
	(calibration_target instrument3 Star4)
	(supports instrument4 infrared0)
	(supports instrument4 thermograph2)
	(supports instrument4 thermograph1)
	(calibration_target instrument4 Star5)
	(calibration_target instrument4 Star12)
	(calibration_target instrument4 GroundStation6)
	(calibration_target instrument4 Star2)
	(supports instrument5 spectrograph6)
	(supports instrument5 image3)
	(supports instrument5 thermograph1)
	(calibration_target instrument5 Star8)
	(calibration_target instrument5 Star0)
	(calibration_target instrument5 GroundStation6)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet13)
	(supports instrument6 infrared0)
	(supports instrument6 infrared4)
	(supports instrument6 thermograph2)
	(calibration_target instrument6 Star0)
	(calibration_target instrument6 Star9)
	(supports instrument7 thermograph5)
	(supports instrument7 infrared0)
	(calibration_target instrument7 GroundStation1)
	(calibration_target instrument7 GroundStation3)
	(calibration_target instrument7 Star5)
	(supports instrument8 thermograph2)
	(supports instrument8 thermograph1)
	(calibration_target instrument8 Star11)
	(calibration_target instrument8 Star12)
	(calibration_target instrument8 Star2)
	(on_board instrument6 satellite3)
	(on_board instrument7 satellite3)
	(on_board instrument8 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation6)
	(supports instrument9 thermograph2)
	(supports instrument9 infrared4)
	(calibration_target instrument9 Star9)
	(supports instrument10 image3)
	(supports instrument10 thermograph1)
	(supports instrument10 spectrograph6)
	(calibration_target instrument10 GroundStation10)
	(calibration_target instrument10 Star12)
	(calibration_target instrument10 Star11)
	(on_board instrument9 satellite4)
	(on_board instrument10 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star8)
)
(:goal (and
	(pointing satellite3 GroundStation10)
	(have_image Planet13 infrared0)
	(have_image Planet13 spectrograph6)
	(have_image Star14 image3)
	(have_image Phenomenon15 spectrograph6)
	(have_image Phenomenon15 infrared0)
	(have_image Phenomenon16 thermograph1)
))

)
