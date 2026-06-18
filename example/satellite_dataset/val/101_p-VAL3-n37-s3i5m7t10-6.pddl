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
	thermograph2 - mode
	image3 - mode
	thermograph5 - mode
	spectrograph6 - mode
	infrared4 - mode
	thermograph1 - mode
	infrared0 - mode
	Star2 - direction
	Star5 - direction
	GroundStation1 - direction
	Star8 - direction
	Star4 - direction
	Star9 - direction
	GroundStation7 - direction
	GroundStation3 - direction
	Star0 - direction
	GroundStation6 - direction
	Planet10 - direction
	Phenomenon11 - direction
	Star12 - direction
	Phenomenon13 - direction
)
(:init
	(supports instrument0 spectrograph6)
	(supports instrument0 infrared0)
	(supports instrument0 thermograph5)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 GroundStation6)
	(supports instrument1 image3)
	(supports instrument1 infrared4)
	(calibration_target instrument1 GroundStation7)
	(supports instrument2 infrared0)
	(supports instrument2 spectrograph6)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 GroundStation6)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 GroundStation3)
	(supports instrument3 thermograph1)
	(supports instrument3 spectrograph6)
	(supports instrument3 infrared0)
	(calibration_target instrument3 Star8)
	(calibration_target instrument3 GroundStation3)
	(calibration_target instrument3 GroundStation7)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
	(supports instrument4 infrared4)
	(calibration_target instrument4 GroundStation6)
	(calibration_target instrument4 GroundStation7)
	(calibration_target instrument4 Star4)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star9)
	(supports instrument5 infrared4)
	(calibration_target instrument5 GroundStation7)
	(supports instrument6 thermograph5)
	(supports instrument6 thermograph1)
	(supports instrument6 thermograph2)
	(calibration_target instrument6 GroundStation3)
	(calibration_target instrument6 Star9)
	(supports instrument7 spectrograph6)
	(supports instrument7 image3)
	(calibration_target instrument7 GroundStation3)
	(calibration_target instrument7 GroundStation7)
	(supports instrument8 infrared0)
	(calibration_target instrument8 GroundStation6)
	(calibration_target instrument8 Star0)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation1)
)
(:goal (and
	(pointing satellite2 Planet10)
	(have_image Planet10 infrared4)
	(have_image Planet10 infrared0)
	(have_image Phenomenon11 infrared0)
	(have_image Phenomenon11 infrared4)
	(have_image Star12 thermograph5)
	(have_image Phenomenon13 spectrograph6)
))

)
