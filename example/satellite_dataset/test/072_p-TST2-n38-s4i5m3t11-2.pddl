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
	satellite2 - satellite
	instrument6 - instrument
	instrument7 - instrument
	instrument8 - instrument
	satellite3 - satellite
	instrument9 - instrument
	thermograph1 - mode
	spectrograph0 - mode
	infrared2 - mode
	GroundStation1 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star2 - direction
	Star0 - direction
	GroundStation6 - direction
	GroundStation3 - direction
	GroundStation7 - direction
	Star4 - direction
	GroundStation8 - direction
	Star5 - direction
	Planet11 - direction
	Phenomenon12 - direction
	Phenomenon13 - direction
	Star14 - direction
)
(:init
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 Star5)
	(supports instrument1 thermograph1)
	(supports instrument1 infrared2)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 GroundStation8)
	(calibration_target instrument1 GroundStation3)
	(supports instrument2 spectrograph0)
	(supports instrument2 infrared2)
	(calibration_target instrument2 GroundStation9)
	(calibration_target instrument2 Star5)
	(supports instrument3 thermograph1)
	(supports instrument3 infrared2)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 Star2)
	(calibration_target instrument3 GroundStation3)
	(calibration_target instrument3 GroundStation10)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet11)
	(supports instrument4 infrared2)
	(supports instrument4 thermograph1)
	(calibration_target instrument4 Star0)
	(calibration_target instrument4 Star4)
	(calibration_target instrument4 GroundStation3)
	(supports instrument5 spectrograph0)
	(supports instrument5 thermograph1)
	(supports instrument5 infrared2)
	(calibration_target instrument5 Star2)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon12)
	(supports instrument6 spectrograph0)
	(supports instrument6 thermograph1)
	(supports instrument6 infrared2)
	(calibration_target instrument6 Star0)
	(calibration_target instrument6 GroundStation3)
	(calibration_target instrument6 Star5)
	(supports instrument7 thermograph1)
	(supports instrument7 infrared2)
	(calibration_target instrument7 GroundStation6)
	(calibration_target instrument7 GroundStation3)
	(calibration_target instrument7 Star5)
	(supports instrument8 thermograph1)
	(supports instrument8 spectrograph0)
	(supports instrument8 infrared2)
	(calibration_target instrument8 Star4)
	(calibration_target instrument8 GroundStation7)
	(calibration_target instrument8 GroundStation3)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star14)
	(supports instrument9 infrared2)
	(supports instrument9 spectrograph0)
	(supports instrument9 thermograph1)
	(calibration_target instrument9 Star5)
	(calibration_target instrument9 GroundStation8)
	(calibration_target instrument9 Star4)
	(on_board instrument9 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Phenomenon13)
)
(:goal (and
	(pointing satellite0 GroundStation6)
	(pointing satellite1 Star5)
	(have_image Planet11 spectrograph0)
	(have_image Phenomenon12 infrared2)
	(have_image Phenomenon13 infrared2)
	(have_image Star14 infrared2)
))

)
