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
	instrument6 - instrument
	instrument7 - instrument
	image3 - mode
	infrared1 - mode
	thermograph0 - mode
	image6 - mode
	infrared4 - mode
	image5 - mode
	infrared2 - mode
	GroundStation10 - direction
	Star11 - direction
	GroundStation13 - direction
	Star2 - direction
	Star4 - direction
	GroundStation12 - direction
	Star6 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	GroundStation7 - direction
	GroundStation5 - direction
	GroundStation0 - direction
	Star9 - direction
	Star8 - direction
	Star14 - direction
	Planet15 - direction
	Planet16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 infrared1)
	(supports instrument1 thermograph0)
	(supports instrument1 image6)
	(supports instrument1 infrared2)
	(supports instrument1 infrared4)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 Star6)
	(calibration_target instrument1 Star2)
	(calibration_target instrument1 GroundStation13)
	(supports instrument2 thermograph0)
	(supports instrument2 image5)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 Star9)
	(calibration_target instrument2 GroundStation3)
	(calibration_target instrument2 GroundStation12)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet16)
	(supports instrument3 image3)
	(calibration_target instrument3 GroundStation1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation3)
	(supports instrument4 image6)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 Star6)
	(calibration_target instrument4 Star8)
	(supports instrument5 image6)
	(calibration_target instrument5 GroundStation5)
	(calibration_target instrument5 GroundStation0)
	(calibration_target instrument5 GroundStation3)
	(calibration_target instrument5 GroundStation1)
	(supports instrument6 infrared1)
	(supports instrument6 thermograph0)
	(supports instrument6 image3)
	(calibration_target instrument6 GroundStation7)
	(calibration_target instrument6 GroundStation5)
	(supports instrument7 infrared1)
	(calibration_target instrument7 Star8)
	(calibration_target instrument7 Star9)
	(calibration_target instrument7 GroundStation0)
	(calibration_target instrument7 GroundStation5)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star8)
)
(:goal (and
	(pointing satellite0 GroundStation7)
	(pointing satellite1 Planet15)
	(pointing satellite2 Star14)
	(have_image Star14 image3)
	(have_image Star14 infrared2)
	(have_image Planet15 infrared4)
	(have_image Planet16 image5)
	(have_image Star17 infrared1)
	(have_image Star17 image6)
))

)
