(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	satellite3 - satellite
	instrument4 - instrument
	instrument5 - instrument
	instrument6 - instrument
	instrument7 - instrument
	infrared4 - mode
	thermograph2 - mode
	spectrograph6 - mode
	thermograph5 - mode
	thermograph1 - mode
	infrared0 - mode
	image3 - mode
	Star0 - direction
	Star4 - direction
	GroundStation10 - direction
	Star8 - direction
	GroundStation3 - direction
	Star2 - direction
	Star5 - direction
	GroundStation7 - direction
	Star9 - direction
	GroundStation1 - direction
	GroundStation6 - direction
	Star11 - direction
	Phenomenon12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
)
(:init
	(supports instrument0 infrared4)
	(supports instrument0 image3)
	(supports instrument0 thermograph5)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
	(supports instrument1 thermograph5)
	(supports instrument1 image3)
	(supports instrument1 thermograph2)
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 GroundStation6)
	(supports instrument2 infrared0)
	(supports instrument2 spectrograph6)
	(supports instrument2 thermograph5)
	(calibration_target instrument2 Star2)
	(calibration_target instrument2 Star5)
	(calibration_target instrument2 GroundStation3)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon14)
	(supports instrument3 image3)
	(supports instrument3 infrared4)
	(supports instrument3 thermograph1)
	(calibration_target instrument3 Star2)
	(calibration_target instrument3 GroundStation6)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation3)
	(supports instrument4 infrared0)
	(supports instrument4 thermograph2)
	(supports instrument4 image3)
	(calibration_target instrument4 Star2)
	(calibration_target instrument4 GroundStation1)
	(supports instrument5 thermograph2)
	(calibration_target instrument5 Star5)
	(calibration_target instrument5 Star2)
	(supports instrument6 infrared0)
	(supports instrument6 thermograph1)
	(calibration_target instrument6 GroundStation1)
	(calibration_target instrument6 Star9)
	(calibration_target instrument6 GroundStation7)
	(supports instrument7 spectrograph6)
	(supports instrument7 thermograph2)
	(supports instrument7 infrared4)
	(calibration_target instrument7 GroundStation6)
	(on_board instrument4 satellite3)
	(on_board instrument5 satellite3)
	(on_board instrument6 satellite3)
	(on_board instrument7 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star0)
)
(:goal (and
	(pointing satellite1 Star11)
	(pointing satellite3 GroundStation3)
	(have_image Star11 thermograph2)
	(have_image Star11 image3)
	(have_image Phenomenon12 thermograph1)
	(have_image Phenomenon12 infrared4)
	(have_image Phenomenon13 infrared4)
	(have_image Phenomenon13 spectrograph6)
	(have_image Phenomenon14 image3)
))

)
