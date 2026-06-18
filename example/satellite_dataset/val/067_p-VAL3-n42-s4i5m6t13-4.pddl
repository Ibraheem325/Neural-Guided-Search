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
	satellite2 - satellite
	instrument6 - instrument
	satellite3 - satellite
	instrument7 - instrument
	instrument8 - instrument
	instrument9 - instrument
	instrument10 - instrument
	instrument11 - instrument
	thermograph0 - mode
	infrared4 - mode
	infrared2 - mode
	image5 - mode
	image3 - mode
	infrared1 - mode
	Star1 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation12 - direction
	Star7 - direction
	GroundStation8 - direction
	Star11 - direction
	GroundStation2 - direction
	GroundStation6 - direction
	Star0 - direction
	Star5 - direction
	GroundStation4 - direction
	Star3 - direction
	Planet13 - direction
	Planet14 - direction
	Star15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 image5)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 GroundStation6)
	(supports instrument1 image3)
	(supports instrument1 infrared4)
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 GroundStation2)
	(calibration_target instrument1 GroundStation8)
	(calibration_target instrument1 GroundStation6)
	(supports instrument2 infrared2)
	(supports instrument2 thermograph0)
	(supports instrument2 infrared1)
	(calibration_target instrument2 Star1)
	(calibration_target instrument2 GroundStation12)
	(calibration_target instrument2 Star3)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation12)
	(supports instrument3 infrared2)
	(calibration_target instrument3 GroundStation9)
	(calibration_target instrument3 GroundStation12)
	(calibration_target instrument3 Star0)
	(supports instrument4 thermograph0)
	(supports instrument4 infrared2)
	(supports instrument4 infrared1)
	(calibration_target instrument4 GroundStation10)
	(calibration_target instrument4 Star7)
	(calibration_target instrument4 GroundStation9)
	(calibration_target instrument4 Star0)
	(supports instrument5 thermograph0)
	(calibration_target instrument5 GroundStation4)
	(calibration_target instrument5 Star5)
	(calibration_target instrument5 Star11)
	(calibration_target instrument5 GroundStation12)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star0)
	(supports instrument6 infrared4)
	(calibration_target instrument6 GroundStation4)
	(on_board instrument6 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star11)
	(supports instrument7 infrared2)
	(supports instrument7 thermograph0)
	(calibration_target instrument7 Star7)
	(calibration_target instrument7 GroundStation8)
	(supports instrument8 infrared2)
	(calibration_target instrument8 GroundStation6)
	(calibration_target instrument8 Star0)
	(calibration_target instrument8 Star11)
	(calibration_target instrument8 GroundStation8)
	(supports instrument9 infrared1)
	(supports instrument9 thermograph0)
	(supports instrument9 infrared2)
	(calibration_target instrument9 GroundStation2)
	(calibration_target instrument9 GroundStation6)
	(supports instrument10 infrared1)
	(calibration_target instrument10 GroundStation4)
	(calibration_target instrument10 Star5)
	(calibration_target instrument10 Star0)
	(calibration_target instrument10 GroundStation6)
	(supports instrument11 image3)
	(calibration_target instrument11 Star3)
	(on_board instrument7 satellite3)
	(on_board instrument8 satellite3)
	(on_board instrument9 satellite3)
	(on_board instrument10 satellite3)
	(on_board instrument11 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation2)
)
(:goal (and
	(pointing satellite2 Planet14)
	(pointing satellite3 Planet13)
	(have_image Planet13 infrared1)
	(have_image Planet13 infrared2)
	(have_image Planet14 image5)
	(have_image Star15 thermograph0)
	(have_image Phenomenon16 thermograph0)
))

)
