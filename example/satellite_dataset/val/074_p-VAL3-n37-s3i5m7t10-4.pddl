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
	satellite2 - satellite
	instrument7 - instrument
	instrument8 - instrument
	instrument9 - instrument
	instrument10 - instrument
	instrument11 - instrument
	image5 - mode
	infrared1 - mode
	infrared2 - mode
	infrared4 - mode
	thermograph0 - mode
	image3 - mode
	image6 - mode
	GroundStation7 - direction
	Star9 - direction
	Star2 - direction
	Star6 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	Star8 - direction
	GroundStation0 - direction
	Star4 - direction
	GroundStation5 - direction
	Planet10 - direction
	Planet11 - direction
	Star12 - direction
	Planet13 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 thermograph0)
	(supports instrument0 image5)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 Star8)
	(supports instrument1 infrared4)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 GroundStation3)
	(calibration_target instrument1 Star6)
	(calibration_target instrument1 GroundStation0)
	(supports instrument2 image3)
	(supports instrument2 infrared4)
	(calibration_target instrument2 Star4)
	(supports instrument3 image5)
	(supports instrument3 infrared2)
	(supports instrument3 infrared1)
	(calibration_target instrument3 Star4)
	(calibration_target instrument3 GroundStation5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation5)
	(supports instrument4 infrared1)
	(calibration_target instrument4 Star8)
	(calibration_target instrument4 GroundStation1)
	(supports instrument5 infrared1)
	(calibration_target instrument5 Star6)
	(supports instrument6 image3)
	(supports instrument6 image6)
	(calibration_target instrument6 Star6)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation3)
	(supports instrument7 image6)
	(supports instrument7 thermograph0)
	(calibration_target instrument7 Star4)
	(calibration_target instrument7 GroundStation5)
	(supports instrument8 thermograph0)
	(supports instrument8 image5)
	(supports instrument8 infrared1)
	(calibration_target instrument8 GroundStation3)
	(calibration_target instrument8 GroundStation1)
	(supports instrument9 infrared2)
	(calibration_target instrument9 GroundStation0)
	(calibration_target instrument9 Star8)
	(supports instrument10 thermograph0)
	(supports instrument10 infrared4)
	(supports instrument10 infrared1)
	(calibration_target instrument10 Star4)
	(calibration_target instrument10 GroundStation5)
	(supports instrument11 image5)
	(supports instrument11 image3)
	(calibration_target instrument11 GroundStation5)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(on_board instrument9 satellite2)
	(on_board instrument10 satellite2)
	(on_board instrument11 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation3)
)
(:goal (and
	(have_image Planet10 infrared2)
	(have_image Planet10 infrared4)
	(have_image Planet11 image3)
	(have_image Star12 infrared1)
	(have_image Planet13 infrared1)
))

)
