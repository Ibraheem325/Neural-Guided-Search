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
	satellite3 - satellite
	instrument6 - instrument
	thermograph1 - mode
	image2 - mode
	thermograph0 - mode
	thermograph3 - mode
	GroundStation0 - direction
	GroundStation5 - direction
	Star7 - direction
	Star4 - direction
	GroundStation9 - direction
	Star2 - direction
	GroundStation10 - direction
	GroundStation1 - direction
	GroundStation8 - direction
	Star3 - direction
	GroundStation6 - direction
	Phenomenon11 - direction
	Planet12 - direction
	Star13 - direction
)
(:init
	(supports instrument0 thermograph3)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 Star3)
	(supports instrument1 thermograph1)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 GroundStation6)
	(calibration_target instrument1 Star4)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon11)
	(supports instrument2 thermograph1)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 Star2)
	(supports instrument3 thermograph3)
	(supports instrument3 image2)
	(calibration_target instrument3 GroundStation10)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation8)
	(supports instrument4 thermograph0)
	(supports instrument4 image2)
	(calibration_target instrument4 GroundStation6)
	(calibration_target instrument4 GroundStation1)
	(supports instrument5 thermograph3)
	(calibration_target instrument5 Star3)
	(calibration_target instrument5 GroundStation8)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star4)
	(supports instrument6 thermograph1)
	(calibration_target instrument6 GroundStation6)
	(calibration_target instrument6 Star3)
	(calibration_target instrument6 GroundStation8)
	(on_board instrument6 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star7)
)
(:goal (and
	(pointing satellite0 GroundStation9)
	(pointing satellite1 GroundStation6)
	(pointing satellite2 GroundStation5)
	(have_image Phenomenon11 thermograph3)
	(have_image Planet12 thermograph0)
	(have_image Star13 thermograph1)
))

)
