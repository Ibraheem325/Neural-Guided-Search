(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	instrument3 - instrument
	satellite3 - satellite
	instrument4 - instrument
	instrument5 - instrument
	satellite4 - satellite
	instrument6 - instrument
	satellite5 - satellite
	instrument7 - instrument
	infrared1 - mode
	spectrograph2 - mode
	image0 - mode
	GroundStation1 - direction
	GroundStation6 - direction
	Star7 - direction
	Star9 - direction
	GroundStation11 - direction
	Star15 - direction
	Star16 - direction
	GroundStation18 - direction
	Star14 - direction
	GroundStation17 - direction
	Star19 - direction
	Star4 - direction
	Star8 - direction
	GroundStation12 - direction
	GroundStation0 - direction
	GroundStation20 - direction
	GroundStation3 - direction
	Star10 - direction
	GroundStation2 - direction
	GroundStation13 - direction
	Star5 - direction
	Star21 - direction
	Planet22 - direction
	Phenomenon23 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation20)
	(supports instrument1 spectrograph2)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation17)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 GroundStation0)
	(calibration_target instrument1 Star14)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star4)
	(supports instrument2 image0)
	(supports instrument2 spectrograph2)
	(supports instrument2 infrared1)
	(calibration_target instrument2 Star19)
	(supports instrument3 image0)
	(calibration_target instrument3 Star19)
	(calibration_target instrument3 Star4)
	(on_board instrument2 satellite2)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation12)
	(supports instrument4 spectrograph2)
	(supports instrument4 infrared1)
	(supports instrument4 image0)
	(calibration_target instrument4 Star8)
	(calibration_target instrument4 Star5)
	(calibration_target instrument4 GroundStation12)
	(calibration_target instrument4 GroundStation0)
	(calibration_target instrument4 Star4)
	(calibration_target instrument4 GroundStation2)
	(supports instrument5 image0)
	(supports instrument5 infrared1)
	(calibration_target instrument5 Star10)
	(calibration_target instrument5 GroundStation12)
	(calibration_target instrument5 Star5)
	(on_board instrument4 satellite3)
	(on_board instrument5 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation6)
	(supports instrument6 infrared1)
	(supports instrument6 spectrograph2)
	(supports instrument6 image0)
	(calibration_target instrument6 GroundStation13)
	(calibration_target instrument6 GroundStation2)
	(calibration_target instrument6 Star10)
	(calibration_target instrument6 GroundStation3)
	(calibration_target instrument6 GroundStation20)
	(calibration_target instrument6 Star5)
	(calibration_target instrument6 GroundStation0)
	(on_board instrument6 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation11)
	(supports instrument7 image0)
	(calibration_target instrument7 Star5)
	(on_board instrument7 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Phenomenon23)
)
(:goal (and
	(pointing satellite0 GroundStation6)
	(pointing satellite1 GroundStation2)
	(pointing satellite3 Star19)
	(have_image Star21 image0)
	(have_image Planet22 spectrograph2)
	(have_image Phenomenon23 image0)
))

)
