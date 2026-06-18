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
	satellite3 - satellite
	instrument7 - instrument
	image3 - mode
	infrared1 - mode
	image5 - mode
	thermograph0 - mode
	infrared4 - mode
	image6 - mode
	infrared2 - mode
	GroundStation1 - direction
	Star4 - direction
	Star8 - direction
	GroundStation5 - direction
	Star11 - direction
	Star6 - direction
	GroundStation0 - direction
	GroundStation10 - direction
	Star2 - direction
	Star9 - direction
	GroundStation3 - direction
	GroundStation7 - direction
	Planet12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 image5)
	(calibration_target instrument0 Star11)
	(calibration_target instrument0 GroundStation5)
	(supports instrument1 image6)
	(supports instrument1 infrared4)
	(calibration_target instrument1 GroundStation3)
	(calibration_target instrument1 Star11)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
	(supports instrument2 image5)
	(calibration_target instrument2 Star6)
	(calibration_target instrument2 GroundStation7)
	(supports instrument3 thermograph0)
	(supports instrument3 infrared4)
	(supports instrument3 infrared1)
	(calibration_target instrument3 GroundStation10)
	(calibration_target instrument3 GroundStation0)
	(calibration_target instrument3 Star9)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation7)
	(supports instrument4 image3)
	(calibration_target instrument4 GroundStation10)
	(supports instrument5 image6)
	(calibration_target instrument5 GroundStation7)
	(calibration_target instrument5 GroundStation3)
	(calibration_target instrument5 Star2)
	(supports instrument6 infrared2)
	(supports instrument6 thermograph0)
	(calibration_target instrument6 Star9)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation0)
	(supports instrument7 image6)
	(calibration_target instrument7 GroundStation7)
	(calibration_target instrument7 GroundStation3)
	(calibration_target instrument7 Star9)
	(calibration_target instrument7 Star2)
	(on_board instrument7 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation1)
)
(:goal (and
	(pointing satellite3 Phenomenon14)
	(have_image Planet12 infrared4)
	(have_image Planet12 infrared1)
	(have_image Phenomenon13 infrared1)
	(have_image Phenomenon13 image5)
	(have_image Phenomenon14 image5)
	(have_image Phenomenon15 image6)
))

)
