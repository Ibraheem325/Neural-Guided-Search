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
	satellite3 - satellite
	instrument4 - instrument
	instrument5 - instrument
	instrument6 - instrument
	satellite4 - satellite
	instrument7 - instrument
	instrument8 - instrument
	instrument9 - instrument
	satellite5 - satellite
	instrument10 - instrument
	instrument11 - instrument
	satellite6 - satellite
	instrument12 - instrument
	instrument13 - instrument
	infrared0 - mode
	infrared1 - mode
	spectrograph2 - mode
	spectrograph3 - mode
	GroundStation0 - direction
	Star2 - direction
	Star1 - direction
	Star3 - direction
	Star4 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph3)
	(calibration_target instrument0 Star2)
	(supports instrument1 infrared0)
	(supports instrument1 spectrograph2)
	(calibration_target instrument1 Star2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
	(supports instrument2 spectrograph2)
	(supports instrument2 infrared1)
	(supports instrument2 infrared0)
	(calibration_target instrument2 Star2)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation0)
	(supports instrument3 spectrograph3)
	(supports instrument3 infrared0)
	(calibration_target instrument3 Star1)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star3)
	(supports instrument4 infrared0)
	(calibration_target instrument4 Star2)
	(supports instrument5 spectrograph3)
	(calibration_target instrument5 GroundStation0)
	(supports instrument6 spectrograph3)
	(calibration_target instrument6 Star2)
	(on_board instrument4 satellite3)
	(on_board instrument5 satellite3)
	(on_board instrument6 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation0)
	(supports instrument7 infrared0)
	(supports instrument7 infrared1)
	(supports instrument7 spectrograph2)
	(calibration_target instrument7 GroundStation0)
	(supports instrument8 spectrograph2)
	(supports instrument8 spectrograph3)
	(calibration_target instrument8 Star2)
	(supports instrument9 spectrograph3)
	(supports instrument9 infrared1)
	(calibration_target instrument9 Star2)
	(on_board instrument7 satellite4)
	(on_board instrument8 satellite4)
	(on_board instrument9 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star3)
	(supports instrument10 infrared0)
	(supports instrument10 spectrograph3)
	(calibration_target instrument10 Star1)
	(supports instrument11 spectrograph2)
	(supports instrument11 infrared1)
	(calibration_target instrument11 Star1)
	(on_board instrument10 satellite5)
	(on_board instrument11 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Star2)
	(supports instrument12 spectrograph2)
	(supports instrument12 infrared1)
	(calibration_target instrument12 Star1)
	(supports instrument13 spectrograph2)
	(supports instrument13 spectrograph3)
	(supports instrument13 infrared1)
	(calibration_target instrument13 Star1)
	(on_board instrument12 satellite6)
	(on_board instrument13 satellite6)
	(power_avail satellite6)
	(pointing satellite6 GroundStation0)
)
(:goal (and
	(have_image Star3 infrared0)
	(have_image Star4 infrared0)
))

)
