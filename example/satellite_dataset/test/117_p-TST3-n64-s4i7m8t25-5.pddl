(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	satellite3 - satellite
	instrument6 - instrument
	image0 - mode
	image6 - mode
	infrared4 - mode
	image7 - mode
	infrared5 - mode
	infrared1 - mode
	thermograph2 - mode
	infrared3 - mode
	Star3 - direction
	Star4 - direction
	GroundStation6 - direction
	GroundStation8 - direction
	GroundStation19 - direction
	GroundStation21 - direction
	GroundStation14 - direction
	Star1 - direction
	GroundStation10 - direction
	Star11 - direction
	Star7 - direction
	Star13 - direction
	Star2 - direction
	GroundStation12 - direction
	GroundStation16 - direction
	Star0 - direction
	GroundStation23 - direction
	Star22 - direction
	GroundStation17 - direction
	Star9 - direction
	Star18 - direction
	GroundStation24 - direction
	Star15 - direction
	GroundStation5 - direction
	Star20 - direction
	Star25 - direction
	Planet26 - direction
	Planet27 - direction
	Star28 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 image6)
	(supports instrument0 image7)
	(calibration_target instrument0 GroundStation21)
	(calibration_target instrument0 Star22)
	(calibration_target instrument0 Star15)
	(calibration_target instrument0 GroundStation23)
	(calibration_target instrument0 GroundStation16)
	(calibration_target instrument0 GroundStation14)
	(calibration_target instrument0 Star9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
	(supports instrument1 infrared3)
	(supports instrument1 infrared1)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 GroundStation14)
	(calibration_target instrument1 GroundStation5)
	(calibration_target instrument1 Star11)
	(supports instrument2 image0)
	(supports instrument2 thermograph2)
	(supports instrument2 image7)
	(calibration_target instrument2 Star7)
	(calibration_target instrument2 Star11)
	(calibration_target instrument2 GroundStation24)
	(calibration_target instrument2 GroundStation10)
	(calibration_target instrument2 Star18)
	(calibration_target instrument2 GroundStation16)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet26)
	(supports instrument3 infrared3)
	(supports instrument3 thermograph2)
	(supports instrument3 image6)
	(calibration_target instrument3 Star0)
	(calibration_target instrument3 Star2)
	(calibration_target instrument3 Star13)
	(calibration_target instrument3 GroundStation12)
	(calibration_target instrument3 GroundStation23)
	(supports instrument4 infrared3)
	(supports instrument4 infrared5)
	(supports instrument4 infrared4)
	(calibration_target instrument4 Star0)
	(calibration_target instrument4 GroundStation16)
	(calibration_target instrument4 GroundStation12)
	(supports instrument5 image7)
	(calibration_target instrument5 GroundStation24)
	(calibration_target instrument5 Star18)
	(calibration_target instrument5 Star9)
	(calibration_target instrument5 GroundStation17)
	(calibration_target instrument5 Star22)
	(calibration_target instrument5 GroundStation23)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation10)
	(supports instrument6 infrared5)
	(supports instrument6 image6)
	(supports instrument6 image7)
	(calibration_target instrument6 Star20)
	(calibration_target instrument6 GroundStation5)
	(calibration_target instrument6 Star15)
	(on_board instrument6 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star1)
)
(:goal (and
	(have_image Star25 image0)
	(have_image Star25 image6)
	(have_image Planet26 infrared4)
	(have_image Planet27 thermograph2)
	(have_image Star28 image7)
	(have_image Star28 infrared3)
))

)
