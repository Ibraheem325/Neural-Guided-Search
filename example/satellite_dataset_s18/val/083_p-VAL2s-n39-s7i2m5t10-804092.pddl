(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	instrument5 - instrument
	satellite5 - satellite
	instrument6 - instrument
	satellite6 - satellite
	instrument7 - instrument
	thermograph2 - mode
	thermograph1 - mode
	spectrograph0 - mode
	thermograph3 - mode
	spectrograph4 - mode
	GroundStation6 - direction
	Star9 - direction
	Star2 - direction
	Star7 - direction
	GroundStation0 - direction
	Star1 - direction
	GroundStation5 - direction
	GroundStation3 - direction
	GroundStation8 - direction
	GroundStation4 - direction
	Phenomenon10 - direction
	Planet11 - direction
	Phenomenon12 - direction
	Star13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
	Phenomenon17 - direction
	Star18 - direction
)
(:init
	(supports instrument0 spectrograph4)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon14)
	(supports instrument1 spectrograph4)
	(supports instrument1 spectrograph0)
	(supports instrument1 thermograph3)
	(calibration_target instrument1 Star9)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation4)
	(supports instrument2 thermograph2)
	(supports instrument2 thermograph1)
	(supports instrument2 thermograph3)
	(calibration_target instrument2 Star7)
	(calibration_target instrument2 Star2)
	(calibration_target instrument2 GroundStation0)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon16)
	(supports instrument3 thermograph2)
	(supports instrument3 spectrograph4)
	(calibration_target instrument3 GroundStation0)
	(calibration_target instrument3 Star7)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation8)
	(supports instrument4 spectrograph4)
	(supports instrument4 thermograph1)
	(calibration_target instrument4 Star1)
	(supports instrument5 thermograph1)
	(supports instrument5 thermograph2)
	(supports instrument5 spectrograph4)
	(calibration_target instrument5 GroundStation5)
	(on_board instrument4 satellite4)
	(on_board instrument5 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation3)
	(supports instrument6 spectrograph0)
	(supports instrument6 spectrograph4)
	(supports instrument6 thermograph3)
	(calibration_target instrument6 GroundStation8)
	(calibration_target instrument6 GroundStation3)
	(on_board instrument6 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Phenomenon12)
	(supports instrument7 thermograph2)
	(calibration_target instrument7 GroundStation4)
	(on_board instrument7 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Star13)
)
(:goal (and
	(pointing satellite1 Phenomenon12)
	(pointing satellite4 Phenomenon12)
	(pointing satellite5 Phenomenon14)
	(have_image Phenomenon10 thermograph1)
	(have_image Planet11 thermograph1)
	(have_image Phenomenon12 thermograph1)
	(have_image Star13 spectrograph4)
	(have_image Phenomenon14 spectrograph4)
	(have_image Phenomenon15 thermograph2)
	(have_image Phenomenon16 thermograph3)
	(have_image Phenomenon17 thermograph3)
	(have_image Star18 thermograph3)
))

)
