(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	instrument5 - instrument
	instrument6 - instrument
	instrument7 - instrument
	thermograph1 - mode
	infrared4 - mode
	infrared0 - mode
	thermograph2 - mode
	image3 - mode
	Star7 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation2 - direction
	Star1 - direction
	GroundStation0 - direction
	GroundStation11 - direction
	Star9 - direction
	Star10 - direction
	Star3 - direction
	Star6 - direction
	GroundStation8 - direction
	Star12 - direction
	Star13 - direction
	Star14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 thermograph2)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 Star5)
	(supports instrument1 image3)
	(supports instrument1 thermograph1)
	(supports instrument1 infrared0)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 GroundStation4)
	(calibration_target instrument1 GroundStation2)
	(calibration_target instrument1 GroundStation11)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon15)
	(supports instrument2 infrared4)
	(calibration_target instrument2 Star1)
	(calibration_target instrument2 GroundStation11)
	(supports instrument3 thermograph2)
	(calibration_target instrument3 GroundStation2)
	(calibration_target instrument3 GroundStation0)
	(calibration_target instrument3 Star5)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation8)
	(supports instrument4 infrared4)
	(calibration_target instrument4 Star1)
	(calibration_target instrument4 GroundStation2)
	(supports instrument5 infrared4)
	(supports instrument5 thermograph1)
	(calibration_target instrument5 GroundStation0)
	(calibration_target instrument5 GroundStation8)
	(calibration_target instrument5 Star10)
	(calibration_target instrument5 Star6)
	(supports instrument6 image3)
	(supports instrument6 infrared0)
	(calibration_target instrument6 Star10)
	(calibration_target instrument6 Star9)
	(calibration_target instrument6 GroundStation11)
	(supports instrument7 thermograph2)
	(supports instrument7 image3)
	(supports instrument7 infrared4)
	(calibration_target instrument7 GroundStation8)
	(calibration_target instrument7 Star6)
	(calibration_target instrument7 Star3)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation0)
)
(:goal (and
	(pointing satellite0 GroundStation2)
	(pointing satellite1 Star7)
	(have_image Star12 infrared0)
	(have_image Star13 thermograph2)
	(have_image Star14 infrared0)
	(have_image Phenomenon15 thermograph2)
))

)
