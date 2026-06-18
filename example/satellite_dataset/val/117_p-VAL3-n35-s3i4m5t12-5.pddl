(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	instrument6 - instrument
	satellite2 - satellite
	instrument7 - instrument
	instrument8 - instrument
	thermograph2 - mode
	infrared1 - mode
	infrared4 - mode
	image0 - mode
	infrared3 - mode
	Star2 - direction
	Star8 - direction
	GroundStation11 - direction
	Star1 - direction
	Star0 - direction
	GroundStation4 - direction
	GroundStation7 - direction
	GroundStation6 - direction
	Star10 - direction
	Star9 - direction
	Star3 - direction
	GroundStation5 - direction
	Star12 - direction
	Phenomenon13 - direction
	Star14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 infrared4)
	(supports instrument0 image0)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation7)
	(supports instrument1 infrared3)
	(supports instrument1 image0)
	(supports instrument1 infrared4)
	(calibration_target instrument1 GroundStation6)
	(calibration_target instrument1 Star8)
	(calibration_target instrument1 Star2)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 Star3)
	(calibration_target instrument2 Star9)
	(calibration_target instrument2 Star10)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
	(supports instrument3 infrared3)
	(calibration_target instrument3 GroundStation11)
	(calibration_target instrument3 Star8)
	(supports instrument4 infrared1)
	(supports instrument4 image0)
	(calibration_target instrument4 GroundStation7)
	(calibration_target instrument4 Star10)
	(calibration_target instrument4 Star1)
	(calibration_target instrument4 GroundStation6)
	(supports instrument5 infrared3)
	(supports instrument5 infrared4)
	(supports instrument5 infrared1)
	(calibration_target instrument5 GroundStation4)
	(calibration_target instrument5 Star0)
	(calibration_target instrument5 GroundStation6)
	(calibration_target instrument5 Star10)
	(supports instrument6 thermograph2)
	(calibration_target instrument6 Star10)
	(calibration_target instrument6 GroundStation6)
	(calibration_target instrument6 GroundStation7)
	(calibration_target instrument6 GroundStation5)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon13)
	(supports instrument7 infrared1)
	(supports instrument7 infrared4)
	(calibration_target instrument7 Star9)
	(supports instrument8 infrared4)
	(calibration_target instrument8 GroundStation5)
	(calibration_target instrument8 Star3)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star9)
)
(:goal (and
	(pointing satellite1 Star14)
	(have_image Star12 thermograph2)
	(have_image Phenomenon13 thermograph2)
	(have_image Star14 infrared4)
	(have_image Phenomenon15 infrared4)
))

)
