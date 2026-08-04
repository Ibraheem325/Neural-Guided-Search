(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	satellite3 - satellite
	instrument4 - instrument
	satellite4 - satellite
	instrument5 - instrument
	instrument6 - instrument
	thermograph0 - mode
	Star2 - direction
	Star10 - direction
	Star13 - direction
	GroundStation12 - direction
	GroundStation6 - direction
	Star14 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star1 - direction
	Star11 - direction
	GroundStation8 - direction
	GroundStation7 - direction
	GroundStation5 - direction
	Star9 - direction
	Star0 - direction
	Phenomenon15 - direction
	Star16 - direction
	Star17 - direction
	Phenomenon18 - direction
	Phenomenon19 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 GroundStation12)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star13)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 GroundStation5)
	(calibration_target instrument1 GroundStation6)
	(supports instrument2 thermograph0)
	(calibration_target instrument2 GroundStation3)
	(calibration_target instrument2 Star14)
	(calibration_target instrument2 GroundStation5)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation7)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 GroundStation4)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star9)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 Star11)
	(calibration_target instrument4 Star1)
	(on_board instrument4 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star13)
	(supports instrument5 thermograph0)
	(calibration_target instrument5 GroundStation5)
	(calibration_target instrument5 GroundStation7)
	(calibration_target instrument5 Star0)
	(calibration_target instrument5 Star9)
	(calibration_target instrument5 GroundStation8)
	(supports instrument6 thermograph0)
	(calibration_target instrument6 Star0)
	(calibration_target instrument6 Star9)
	(on_board instrument5 satellite4)
	(on_board instrument6 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation4)
)
(:goal (and
	(pointing satellite1 GroundStation6)
	(pointing satellite2 GroundStation4)
	(have_image Phenomenon15 thermograph0)
	(have_image Star16 thermograph0)
	(have_image Star17 thermograph0)
	(have_image Phenomenon18 thermograph0)
	(have_image Phenomenon19 thermograph0)
))

)
