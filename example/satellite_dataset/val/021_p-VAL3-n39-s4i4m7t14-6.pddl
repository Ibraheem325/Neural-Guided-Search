(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	instrument4 - instrument
	satellite2 - satellite
	instrument5 - instrument
	instrument6 - instrument
	instrument7 - instrument
	satellite3 - satellite
	instrument8 - instrument
	thermograph1 - mode
	infrared0 - mode
	image3 - mode
	thermograph5 - mode
	infrared4 - mode
	spectrograph6 - mode
	thermograph2 - mode
	Star11 - direction
	Star9 - direction
	Star4 - direction
	GroundStation10 - direction
	GroundStation7 - direction
	GroundStation13 - direction
	GroundStation1 - direction
	Star5 - direction
	GroundStation3 - direction
	Star8 - direction
	Star0 - direction
	Star2 - direction
	GroundStation6 - direction
	Star12 - direction
	Phenomenon14 - direction
	Star15 - direction
	Phenomenon16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 thermograph2)
	(supports instrument0 image3)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 GroundStation6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation7)
	(supports instrument1 thermograph2)
	(supports instrument1 infrared0)
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 Star12)
	(supports instrument2 thermograph5)
	(calibration_target instrument2 Star0)
	(supports instrument3 spectrograph6)
	(calibration_target instrument3 GroundStation7)
	(calibration_target instrument3 GroundStation6)
	(supports instrument4 infrared4)
	(supports instrument4 thermograph2)
	(supports instrument4 thermograph1)
	(calibration_target instrument4 Star4)
	(calibration_target instrument4 Star8)
	(calibration_target instrument4 Star2)
	(calibration_target instrument4 GroundStation1)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon16)
	(supports instrument5 thermograph2)
	(calibration_target instrument5 GroundStation3)
	(calibration_target instrument5 GroundStation10)
	(calibration_target instrument5 GroundStation6)
	(supports instrument6 spectrograph6)
	(supports instrument6 image3)
	(calibration_target instrument6 GroundStation13)
	(calibration_target instrument6 GroundStation7)
	(calibration_target instrument6 Star0)
	(supports instrument7 thermograph1)
	(supports instrument7 infrared4)
	(calibration_target instrument7 Star8)
	(calibration_target instrument7 GroundStation3)
	(calibration_target instrument7 Star5)
	(calibration_target instrument7 GroundStation1)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star9)
	(supports instrument8 infrared4)
	(supports instrument8 image3)
	(supports instrument8 thermograph5)
	(calibration_target instrument8 Star12)
	(calibration_target instrument8 GroundStation6)
	(calibration_target instrument8 Star2)
	(calibration_target instrument8 Star0)
	(on_board instrument8 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star8)
)
(:goal (and
	(pointing satellite0 Phenomenon14)
	(pointing satellite2 Phenomenon14)
	(pointing satellite3 Star0)
	(have_image Phenomenon14 image3)
	(have_image Star15 infrared0)
	(have_image Star15 infrared4)
	(have_image Phenomenon16 thermograph1)
	(have_image Phenomenon16 infrared4)
	(have_image Planet17 image3)
))

)
