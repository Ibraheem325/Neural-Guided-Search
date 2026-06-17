(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	instrument4 - instrument
	satellite1 - satellite
	instrument5 - instrument
	satellite2 - satellite
	instrument6 - instrument
	instrument7 - instrument
	instrument8 - instrument
	satellite3 - satellite
	instrument9 - instrument
	instrument10 - instrument
	satellite4 - satellite
	instrument11 - instrument
	instrument12 - instrument
	infrared1 - mode
	thermograph2 - mode
	image0 - mode
	Star1 - direction
	Star4 - direction
	GroundStation5 - direction
	Star11 - direction
	GroundStation13 - direction
	Star6 - direction
	GroundStation8 - direction
	Star3 - direction
	GroundStation7 - direction
	Star2 - direction
	Star12 - direction
	Star10 - direction
	Star9 - direction
	Star0 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star11)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 GroundStation5)
	(supports instrument1 infrared1)
	(calibration_target instrument1 GroundStation13)
	(calibration_target instrument1 Star12)
	(calibration_target instrument1 Star0)
	(supports instrument2 infrared1)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 GroundStation8)
	(calibration_target instrument2 GroundStation5)
	(calibration_target instrument2 Star0)
	(calibration_target instrument2 Star6)
	(supports instrument3 thermograph2)
	(calibration_target instrument3 Star6)
	(calibration_target instrument3 Star9)
	(supports instrument4 image0)
	(calibration_target instrument4 Star2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(on_board instrument4 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon17)
	(supports instrument5 thermograph2)
	(calibration_target instrument5 Star2)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon17)
	(supports instrument6 infrared1)
	(calibration_target instrument6 Star2)
	(calibration_target instrument6 Star11)
	(calibration_target instrument6 Star12)
	(calibration_target instrument6 Star3)
	(supports instrument7 image0)
	(supports instrument7 thermograph2)
	(calibration_target instrument7 GroundStation13)
	(supports instrument8 thermograph2)
	(calibration_target instrument8 GroundStation8)
	(calibration_target instrument8 Star6)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon17)
	(supports instrument9 infrared1)
	(supports instrument9 image0)
	(calibration_target instrument9 Star3)
	(calibration_target instrument9 Star9)
	(supports instrument10 infrared1)
	(calibration_target instrument10 Star2)
	(calibration_target instrument10 GroundStation7)
	(on_board instrument9 satellite3)
	(on_board instrument10 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star10)
	(supports instrument11 infrared1)
	(supports instrument11 image0)
	(supports instrument11 thermograph2)
	(calibration_target instrument11 Star12)
	(supports instrument12 image0)
	(calibration_target instrument12 Star0)
	(calibration_target instrument12 Star9)
	(calibration_target instrument12 Star10)
	(on_board instrument11 satellite4)
	(on_board instrument12 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star10)
)
(:goal (and
	(pointing satellite0 Phenomenon15)
	(pointing satellite2 Star4)
	(pointing satellite3 Star11)
	(have_image Planet14 infrared1)
	(have_image Phenomenon15 thermograph2)
	(have_image Phenomenon16 thermograph2)
	(have_image Phenomenon17 image0)
))

)
