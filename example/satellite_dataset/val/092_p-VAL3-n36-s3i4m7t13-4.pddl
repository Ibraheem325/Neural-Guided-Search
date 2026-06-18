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
	thermograph0 - mode
	image5 - mode
	infrared2 - mode
	image3 - mode
	infrared1 - mode
	infrared4 - mode
	image6 - mode
	GroundStation10 - direction
	Star11 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation5 - direction
	GroundStation0 - direction
	Star6 - direction
	GroundStation12 - direction
	GroundStation7 - direction
	Star9 - direction
	Star8 - direction
	Star4 - direction
	GroundStation3 - direction
	Planet13 - direction
	Phenomenon14 - direction
	Star15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 image3)
	(calibration_target instrument0 GroundStation5)
	(supports instrument1 infrared4)
	(supports instrument1 image6)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 GroundStation1)
	(calibration_target instrument1 Star11)
	(calibration_target instrument1 GroundStation10)
	(supports instrument2 image5)
	(supports instrument2 thermograph0)
	(supports instrument2 infrared2)
	(calibration_target instrument2 GroundStation5)
	(calibration_target instrument2 Star9)
	(calibration_target instrument2 Star2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation5)
	(supports instrument3 image5)
	(calibration_target instrument3 Star6)
	(calibration_target instrument3 Star9)
	(calibration_target instrument3 GroundStation0)
	(supports instrument4 thermograph0)
	(supports instrument4 image5)
	(supports instrument4 infrared2)
	(calibration_target instrument4 GroundStation7)
	(calibration_target instrument4 GroundStation12)
	(calibration_target instrument4 Star6)
	(calibration_target instrument4 GroundStation0)
	(supports instrument5 image5)
	(calibration_target instrument5 GroundStation3)
	(calibration_target instrument5 Star4)
	(calibration_target instrument5 Star8)
	(calibration_target instrument5 Star9)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation0)
	(supports instrument6 infrared1)
	(calibration_target instrument6 GroundStation3)
	(on_board instrument6 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star8)
)
(:goal (and
	(pointing satellite2 Phenomenon14)
	(have_image Planet13 infrared2)
	(have_image Phenomenon14 image3)
	(have_image Phenomenon14 thermograph0)
	(have_image Star15 image5)
	(have_image Star15 infrared1)
	(have_image Phenomenon16 thermograph0)
))

)
