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
	instrument6 - instrument
	instrument7 - instrument
	infrared5 - mode
	spectrograph1 - mode
	spectrograph2 - mode
	infrared3 - mode
	spectrograph0 - mode
	thermograph4 - mode
	GroundStation3 - direction
	Star6 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	GroundStation0 - direction
	Star1 - direction
	GroundStation4 - direction
	Star8 - direction
	Star7 - direction
	GroundStation2 - direction
	Star5 - direction
	Planet12 - direction
	Star13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph2)
	(supports instrument0 infrared3)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 spectrograph2)
	(supports instrument1 infrared3)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 GroundStation4)
	(supports instrument2 spectrograph2)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 GroundStation4)
	(supports instrument3 thermograph4)
	(supports instrument3 infrared5)
	(calibration_target instrument3 Star8)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star13)
	(supports instrument4 infrared3)
	(supports instrument4 spectrograph2)
	(calibration_target instrument4 Star7)
	(supports instrument5 infrared5)
	(supports instrument5 infrared3)
	(calibration_target instrument5 Star7)
	(calibration_target instrument5 Star8)
	(supports instrument6 spectrograph0)
	(calibration_target instrument6 GroundStation2)
	(calibration_target instrument6 Star5)
	(supports instrument7 spectrograph0)
	(supports instrument7 infrared5)
	(supports instrument7 spectrograph2)
	(calibration_target instrument7 Star5)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(on_board instrument7 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet12)
)
(:goal (and
	(pointing satellite1 Phenomenon15)
	(have_image Planet12 spectrograph1)
	(have_image Planet12 infrared3)
	(have_image Star13 spectrograph2)
	(have_image Star13 infrared3)
	(have_image Phenomenon14 spectrograph1)
	(have_image Phenomenon14 spectrograph2)
	(have_image Phenomenon15 spectrograph1)
))

)
