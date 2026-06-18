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
	spectrograph1 - mode
	spectrograph0 - mode
	spectrograph2 - mode
	infrared3 - mode
	Star9 - direction
	Star8 - direction
	GroundStation13 - direction
	GroundStation7 - direction
	GroundStation6 - direction
	Star11 - direction
	Star12 - direction
	Star1 - direction
	Star5 - direction
	Star10 - direction
	GroundStation0 - direction
	Star4 - direction
	GroundStation3 - direction
	GroundStation2 - direction
	Planet14 - direction
	Planet15 - direction
	Planet16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star12)
	(calibration_target instrument0 GroundStation13)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 Star1)
	(supports instrument1 spectrograph1)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 Star1)
	(supports instrument2 infrared3)
	(supports instrument2 spectrograph1)
	(calibration_target instrument2 GroundStation7)
	(calibration_target instrument2 Star12)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 Star11)
	(calibration_target instrument3 Star4)
	(calibration_target instrument3 GroundStation6)
	(calibration_target instrument3 GroundStation3)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet14)
	(supports instrument4 spectrograph2)
	(calibration_target instrument4 Star4)
	(supports instrument5 spectrograph1)
	(supports instrument5 spectrograph0)
	(calibration_target instrument5 Star12)
	(supports instrument6 spectrograph2)
	(supports instrument6 spectrograph1)
	(calibration_target instrument6 GroundStation0)
	(calibration_target instrument6 Star10)
	(calibration_target instrument6 Star5)
	(calibration_target instrument6 Star1)
	(supports instrument7 spectrograph1)
	(supports instrument7 spectrograph2)
	(calibration_target instrument7 GroundStation2)
	(calibration_target instrument7 GroundStation3)
	(calibration_target instrument7 Star4)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(on_board instrument7 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet15)
)
(:goal (and
	(pointing satellite0 GroundStation0)
	(have_image Planet14 spectrograph2)
	(have_image Planet15 spectrograph2)
	(have_image Planet16 spectrograph2)
	(have_image Star17 spectrograph1)
))

)
