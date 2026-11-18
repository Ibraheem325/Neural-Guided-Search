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
	satellite2 - satellite
	instrument5 - instrument
	instrument6 - instrument
	thermograph0 - mode
	Star1 - direction
	GroundStation4 - direction
	Star5 - direction
	Star10 - direction
	GroundStation11 - direction
	Star2 - direction
	Star14 - direction
	GroundStation3 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation12 - direction
	GroundStation13 - direction
	Star0 - direction
	Star9 - direction
	Star8 - direction
	Star15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation11)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 Star0)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 Star2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
	(supports instrument2 thermograph0)
	(calibration_target instrument2 Star14)
	(calibration_target instrument2 Star8)
	(calibration_target instrument2 Star0)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 GroundStation3)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 GroundStation6)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation6)
	(supports instrument5 thermograph0)
	(calibration_target instrument5 GroundStation7)
	(calibration_target instrument5 Star9)
	(supports instrument6 thermograph0)
	(calibration_target instrument6 Star8)
	(calibration_target instrument6 Star9)
	(calibration_target instrument6 Star0)
	(calibration_target instrument6 GroundStation13)
	(calibration_target instrument6 GroundStation12)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation13)
)
(:goal (and
	(pointing satellite0 Star5)
	(have_image Star15 thermograph0)
	(have_image Phenomenon16 thermograph0)
))

)
