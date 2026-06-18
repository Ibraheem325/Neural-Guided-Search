(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	satellite2 - satellite
	instrument6 - instrument
	instrument7 - instrument
	satellite3 - satellite
	instrument8 - instrument
	instrument9 - instrument
	instrument10 - instrument
	infrared1 - mode
	infrared3 - mode
	infrared5 - mode
	infrared4 - mode
	thermograph2 - mode
	image6 - mode
	image0 - mode
	GroundStation11 - direction
	Star6 - direction
	Star3 - direction
	Star10 - direction
	GroundStation4 - direction
	Star5 - direction
	Star2 - direction
	Star9 - direction
	Star1 - direction
	Star7 - direction
	Star0 - direction
	GroundStation12 - direction
	Star8 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Star16 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 infrared4)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 Star10)
	(supports instrument1 thermograph2)
	(supports instrument1 image6)
	(supports instrument1 infrared3)
	(calibration_target instrument1 Star10)
	(calibration_target instrument1 Star3)
	(calibration_target instrument1 Star6)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation11)
	(supports instrument2 infrared1)
	(calibration_target instrument2 GroundStation12)
	(calibration_target instrument2 Star1)
	(supports instrument3 thermograph2)
	(supports instrument3 image0)
	(calibration_target instrument3 Star7)
	(calibration_target instrument3 Star9)
	(calibration_target instrument3 GroundStation4)
	(supports instrument4 infrared3)
	(supports instrument4 infrared1)
	(supports instrument4 infrared5)
	(calibration_target instrument4 Star2)
	(supports instrument5 infrared3)
	(calibration_target instrument5 Star7)
	(calibration_target instrument5 GroundStation12)
	(calibration_target instrument5 Star0)
	(calibration_target instrument5 Star9)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star3)
	(supports instrument6 thermograph2)
	(calibration_target instrument6 Star5)
	(calibration_target instrument6 Star8)
	(calibration_target instrument6 GroundStation12)
	(supports instrument7 infrared5)
	(calibration_target instrument7 Star1)
	(calibration_target instrument7 Star9)
	(calibration_target instrument7 Star2)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star7)
	(supports instrument8 image0)
	(supports instrument8 infrared1)
	(calibration_target instrument8 Star7)
	(supports instrument9 infrared4)
	(calibration_target instrument9 Star0)
	(supports instrument10 thermograph2)
	(calibration_target instrument10 Star8)
	(calibration_target instrument10 GroundStation12)
	(calibration_target instrument10 Star0)
	(on_board instrument8 satellite3)
	(on_board instrument9 satellite3)
	(on_board instrument10 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star10)
)
(:goal (and
	(pointing satellite0 Star2)
	(have_image Phenomenon13 infrared3)
	(have_image Phenomenon14 infrared1)
	(have_image Phenomenon14 image0)
	(have_image Phenomenon15 infrared1)
	(have_image Phenomenon15 infrared4)
	(have_image Star16 image0)
	(have_image Star16 infrared5)
))

)
