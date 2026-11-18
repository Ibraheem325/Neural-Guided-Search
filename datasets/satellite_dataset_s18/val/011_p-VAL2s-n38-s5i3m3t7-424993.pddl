(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	instrument5 - instrument
	satellite3 - satellite
	instrument6 - instrument
	instrument7 - instrument
	satellite4 - satellite
	instrument8 - instrument
	instrument9 - instrument
	instrument10 - instrument
	thermograph0 - mode
	infrared2 - mode
	thermograph1 - mode
	Star1 - direction
	GroundStation6 - direction
	Star0 - direction
	GroundStation5 - direction
	Star4 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Planet7 - direction
	Phenomenon8 - direction
	Planet9 - direction
	Planet10 - direction
	Star11 - direction
	Planet12 - direction
	Phenomenon13 - direction
	Star14 - direction
	Star15 - direction
	Planet16 - direction
	Star17 - direction
	Phenomenon18 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared2)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation3)
	(supports instrument1 infrared2)
	(supports instrument1 thermograph0)
	(supports instrument1 thermograph1)
	(calibration_target instrument1 GroundStation2)
	(supports instrument2 infrared2)
	(supports instrument2 thermograph1)
	(calibration_target instrument2 Star4)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon13)
	(supports instrument3 thermograph1)
	(supports instrument3 infrared2)
	(calibration_target instrument3 GroundStation5)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet12)
	(supports instrument4 thermograph0)
	(supports instrument4 thermograph1)
	(calibration_target instrument4 Star0)
	(calibration_target instrument4 Star1)
	(supports instrument5 thermograph0)
	(supports instrument5 infrared2)
	(calibration_target instrument5 GroundStation2)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon18)
	(supports instrument6 thermograph0)
	(supports instrument6 infrared2)
	(supports instrument6 thermograph1)
	(calibration_target instrument6 Star0)
	(calibration_target instrument6 GroundStation6)
	(supports instrument7 infrared2)
	(supports instrument7 thermograph1)
	(calibration_target instrument7 GroundStation5)
	(on_board instrument6 satellite3)
	(on_board instrument7 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet16)
	(supports instrument8 thermograph1)
	(calibration_target instrument8 GroundStation3)
	(calibration_target instrument8 Star4)
	(supports instrument9 thermograph0)
	(supports instrument9 infrared2)
	(calibration_target instrument9 GroundStation3)
	(supports instrument10 infrared2)
	(supports instrument10 thermograph1)
	(supports instrument10 thermograph0)
	(calibration_target instrument10 GroundStation3)
	(calibration_target instrument10 GroundStation2)
	(on_board instrument8 satellite4)
	(on_board instrument9 satellite4)
	(on_board instrument10 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation5)
)
(:goal (and
	(pointing satellite0 Star1)
	(pointing satellite1 Star15)
	(pointing satellite2 GroundStation5)
	(pointing satellite3 Phenomenon18)
	(have_image Planet7 infrared2)
	(have_image Phenomenon8 thermograph1)
	(have_image Planet9 thermograph0)
	(have_image Planet10 thermograph1)
	(have_image Star11 thermograph0)
	(have_image Planet12 thermograph1)
	(have_image Phenomenon13 thermograph1)
	(have_image Star14 infrared2)
	(have_image Star15 thermograph1)
	(have_image Planet16 infrared2)
	(have_image Star17 thermograph1)
	(have_image Phenomenon18 infrared2)
))

)
