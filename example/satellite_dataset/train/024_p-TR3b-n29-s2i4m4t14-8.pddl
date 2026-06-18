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
	image0 - mode
	infrared3 - mode
	thermograph1 - mode
	thermograph2 - mode
	GroundStation12 - direction
	Star13 - direction
	Star6 - direction
	Star7 - direction
	GroundStation2 - direction
	GroundStation1 - direction
	GroundStation5 - direction
	Star4 - direction
	GroundStation11 - direction
	GroundStation3 - direction
	GroundStation0 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Planet14 - direction
	Star15 - direction
	Planet16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 infrared3)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star4)
	(supports instrument1 infrared3)
	(supports instrument1 thermograph2)
	(calibration_target instrument1 Star6)
	(supports instrument2 infrared3)
	(supports instrument2 thermograph1)
	(supports instrument2 image0)
	(calibration_target instrument2 GroundStation10)
	(supports instrument3 image0)
	(calibration_target instrument3 GroundStation5)
	(calibration_target instrument3 Star4)
	(calibration_target instrument3 GroundStation2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
	(supports instrument4 thermograph1)
	(supports instrument4 image0)
	(calibration_target instrument4 GroundStation1)
	(calibration_target instrument4 GroundStation2)
	(calibration_target instrument4 Star7)
	(calibration_target instrument4 Star6)
	(supports instrument5 image0)
	(calibration_target instrument5 GroundStation11)
	(calibration_target instrument5 GroundStation0)
	(calibration_target instrument5 Star4)
	(calibration_target instrument5 GroundStation5)
	(supports instrument6 infrared3)
	(supports instrument6 image0)
	(calibration_target instrument6 GroundStation9)
	(calibration_target instrument6 Star8)
	(calibration_target instrument6 GroundStation0)
	(calibration_target instrument6 GroundStation3)
	(supports instrument7 image0)
	(supports instrument7 infrared3)
	(calibration_target instrument7 GroundStation10)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(on_board instrument7 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet14)
)
(:goal (and
	(have_image Planet14 infrared3)
	(have_image Star15 thermograph2)
	(have_image Planet16 infrared3)
	(have_image Star17 infrared3)
))

)
