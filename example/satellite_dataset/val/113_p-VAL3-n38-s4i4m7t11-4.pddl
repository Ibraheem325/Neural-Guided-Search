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
	instrument8 - instrument
	instrument9 - instrument
	satellite3 - satellite
	instrument10 - instrument
	instrument11 - instrument
	instrument12 - instrument
	infrared2 - mode
	thermograph0 - mode
	image6 - mode
	infrared1 - mode
	image5 - mode
	infrared4 - mode
	image3 - mode
	GroundStation3 - direction
	GroundStation1 - direction
	GroundStation5 - direction
	Star2 - direction
	Star6 - direction
	GroundStation10 - direction
	Star9 - direction
	GroundStation0 - direction
	GroundStation7 - direction
	Star8 - direction
	Star4 - direction
	Star11 - direction
	Star12 - direction
	Phenomenon13 - direction
	Planet14 - direction
)
(:init
	(supports instrument0 image3)
	(supports instrument0 infrared4)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 thermograph0)
	(supports instrument1 infrared2)
	(supports instrument1 image3)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 Star2)
	(calibration_target instrument1 Star8)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
	(supports instrument2 infrared4)
	(supports instrument2 infrared1)
	(calibration_target instrument2 GroundStation7)
	(supports instrument3 image3)
	(supports instrument3 infrared2)
	(calibration_target instrument3 GroundStation1)
	(calibration_target instrument3 Star6)
	(supports instrument4 image6)
	(supports instrument4 infrared1)
	(supports instrument4 infrared2)
	(calibration_target instrument4 GroundStation10)
	(calibration_target instrument4 Star4)
	(supports instrument5 image3)
	(supports instrument5 infrared4)
	(calibration_target instrument5 Star8)
	(calibration_target instrument5 GroundStation1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation10)
	(supports instrument6 image5)
	(supports instrument6 image6)
	(supports instrument6 infrared1)
	(calibration_target instrument6 GroundStation7)
	(calibration_target instrument6 GroundStation0)
	(supports instrument7 thermograph0)
	(supports instrument7 infrared2)
	(calibration_target instrument7 Star2)
	(calibration_target instrument7 GroundStation5)
	(calibration_target instrument7 Star8)
	(supports instrument8 infrared4)
	(calibration_target instrument8 Star9)
	(calibration_target instrument8 GroundStation10)
	(calibration_target instrument8 Star6)
	(supports instrument9 image6)
	(calibration_target instrument9 Star9)
	(calibration_target instrument9 Star8)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(on_board instrument9 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation7)
	(supports instrument10 image6)
	(calibration_target instrument10 GroundStation0)
	(supports instrument11 image6)
	(supports instrument11 thermograph0)
	(supports instrument11 infrared4)
	(calibration_target instrument11 Star8)
	(calibration_target instrument11 Star4)
	(calibration_target instrument11 GroundStation7)
	(supports instrument12 image6)
	(supports instrument12 infrared1)
	(calibration_target instrument12 Star4)
	(on_board instrument10 satellite3)
	(on_board instrument11 satellite3)
	(on_board instrument12 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation5)
)
(:goal (and
	(pointing satellite1 GroundStation7)
	(pointing satellite3 Star2)
	(have_image Star11 infrared1)
	(have_image Star12 thermograph0)
	(have_image Phenomenon13 image6)
	(have_image Planet14 image3)
	(have_image Planet14 image5)
))

)
