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
	satellite5 - satellite
	instrument5 - instrument
	satellite6 - satellite
	instrument6 - instrument
	spectrograph0 - mode
	thermograph4 - mode
	spectrograph1 - mode
	spectrograph3 - mode
	spectrograph2 - mode
	Star2 - direction
	GroundStation0 - direction
	Star1 - direction
	Phenomenon3 - direction
	Planet4 - direction
	Phenomenon5 - direction
	Phenomenon6 - direction
	Planet7 - direction
	Star8 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph0)
	(supports instrument0 spectrograph3)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet4)
	(supports instrument1 spectrograph3)
	(supports instrument1 spectrograph1)
	(calibration_target instrument1 Star1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon6)
	(supports instrument2 spectrograph1)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 GroundStation0)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet4)
	(supports instrument3 spectrograph2)
	(calibration_target instrument3 Star1)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Phenomenon5)
	(supports instrument4 spectrograph3)
	(supports instrument4 spectrograph2)
	(calibration_target instrument4 GroundStation0)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star2)
	(supports instrument5 spectrograph3)
	(calibration_target instrument5 GroundStation0)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Planet4)
	(supports instrument6 spectrograph2)
	(supports instrument6 thermograph4)
	(supports instrument6 spectrograph0)
	(calibration_target instrument6 Star1)
	(on_board instrument6 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Star8)
)
(:goal (and
	(pointing satellite0 Star8)
	(have_image Phenomenon3 spectrograph0)
	(have_image Planet4 spectrograph0)
	(have_image Phenomenon5 thermograph4)
	(have_image Phenomenon6 spectrograph2)
	(have_image Planet7 spectrograph3)
	(have_image Star8 spectrograph2)
))

)
