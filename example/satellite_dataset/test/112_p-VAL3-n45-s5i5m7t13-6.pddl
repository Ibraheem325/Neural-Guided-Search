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
	instrument7 - instrument
	satellite2 - satellite
	instrument8 - instrument
	instrument9 - instrument
	satellite3 - satellite
	instrument10 - instrument
	satellite4 - satellite
	instrument11 - instrument
	instrument12 - instrument
	instrument13 - instrument
	infrared4 - mode
	spectrograph6 - mode
	thermograph2 - mode
	image3 - mode
	thermograph5 - mode
	infrared0 - mode
	thermograph1 - mode
	Star0 - direction
	Star11 - direction
	GroundStation3 - direction
	GroundStation7 - direction
	Star8 - direction
	GroundStation1 - direction
	Star12 - direction
	Star9 - direction
	GroundStation6 - direction
	Star4 - direction
	Star2 - direction
	Star5 - direction
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
	(supports instrument2 image3)
	(calibration_target instrument2 GroundStation10)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
	(supports instrument3 thermograph5)
	(calibration_target instrument3 Star2)
	(calibration_target instrument3 GroundStation7)
	(supports instrument4 thermograph1)
	(supports instrument4 infrared0)
	(supports instrument4 image3)
	(calibration_target instrument4 Star0)
	(calibration_target instrument4 GroundStation3)
	(calibration_target instrument4 Star2)
	(supports instrument5 thermograph1)
	(supports instrument5 infrared4)
	(calibration_target instrument5 Star4)
	(calibration_target instrument5 GroundStation3)
	(calibration_target instrument5 Star5)
	(calibration_target instrument5 Star8)
	(supports instrument6 thermograph1)
	(supports instrument6 spectrograph6)
	(supports instrument6 thermograph2)
	(calibration_target instrument6 GroundStation1)
	(supports instrument7 thermograph5)
	(calibration_target instrument7 Star5)
	(calibration_target instrument7 Star0)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(on_board instrument7 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star2)
	(supports instrument8 image3)
	(calibration_target instrument8 Star5)
	(calibration_target instrument8 Star2)
	(calibration_target instrument8 Star11)
	(supports instrument9 infrared0)
	(calibration_target instrument9 GroundStation3)
	(calibration_target instrument9 Star9)
	(calibration_target instrument9 Star2)
	(calibration_target instrument9 Star4)
	(on_board instrument8 satellite2)
	(on_board instrument9 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet13)
	(supports instrument10 spectrograph6)
	(supports instrument10 thermograph1)
	(calibration_target instrument10 GroundStation1)
	(calibration_target instrument10 Star8)
	(calibration_target instrument10 GroundStation7)
	(on_board instrument10 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation7)
	(supports instrument11 spectrograph6)
	(supports instrument11 infrared4)
	(calibration_target instrument11 GroundStation6)
	(calibration_target instrument11 Star9)
	(calibration_target instrument11 Star12)
	(supports instrument12 infrared4)
	(calibration_target instrument12 Star4)
	(supports instrument13 thermograph1)
	(supports instrument13 infrared4)
	(calibration_target instrument13 GroundStation10)
	(calibration_target instrument13 Star5)
	(calibration_target instrument13 Star2)
	(calibration_target instrument13 Star4)
	(on_board instrument11 satellite4)
	(on_board instrument12 satellite4)
	(on_board instrument13 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star0)
)
(:goal (and
	(pointing satellite1 GroundStation6)
	(pointing satellite3 Star0)
	(pointing satellite4 GroundStation1)
	(have_image Planet13 infrared0)
	(have_image Planet13 spectrograph6)
	(have_image Star14 image3)
	(have_image Phenomenon15 spectrograph6)
	(have_image Phenomenon15 infrared0)
	(have_image Phenomenon16 thermograph1)
))

)
