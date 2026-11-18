(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	instrument3 - instrument
	satellite3 - satellite
	instrument4 - instrument
	satellite4 - satellite
	instrument5 - instrument
	satellite5 - satellite
	instrument6 - instrument
	satellite6 - satellite
	instrument7 - instrument
	instrument8 - instrument
	satellite7 - satellite
	instrument9 - instrument
	thermograph0 - mode
	Star13 - direction
	Star7 - direction
	GroundStation8 - direction
	Star2 - direction
	GroundStation1 - direction
	Star11 - direction
	GroundStation0 - direction
	GroundStation12 - direction
	Star6 - direction
	Star14 - direction
	Star4 - direction
	Star5 - direction
	GroundStation10 - direction
	Star9 - direction
	GroundStation3 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star14)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon15)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 Star7)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 GroundStation12)
	(calibration_target instrument1 Star14)
	(calibration_target instrument1 Star4)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation1)
	(supports instrument2 thermograph0)
	(calibration_target instrument2 Star4)
	(calibration_target instrument2 Star9)
	(calibration_target instrument2 GroundStation10)
	(calibration_target instrument2 Star7)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 Star6)
	(calibration_target instrument3 GroundStation1)
	(calibration_target instrument3 Star2)
	(calibration_target instrument3 GroundStation8)
	(on_board instrument2 satellite2)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star5)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 Star11)
	(on_board instrument4 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Phenomenon15)
	(supports instrument5 thermograph0)
	(calibration_target instrument5 GroundStation3)
	(calibration_target instrument5 Star4)
	(calibration_target instrument5 Star6)
	(calibration_target instrument5 GroundStation10)
	(on_board instrument5 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star4)
	(supports instrument6 thermograph0)
	(calibration_target instrument6 GroundStation3)
	(calibration_target instrument6 Star9)
	(calibration_target instrument6 GroundStation0)
	(calibration_target instrument6 GroundStation10)
	(on_board instrument6 satellite5)
	(power_avail satellite5)
	(pointing satellite5 GroundStation1)
	(supports instrument7 thermograph0)
	(calibration_target instrument7 Star6)
	(calibration_target instrument7 GroundStation12)
	(supports instrument8 thermograph0)
	(calibration_target instrument8 GroundStation10)
	(calibration_target instrument8 GroundStation3)
	(calibration_target instrument8 Star5)
	(calibration_target instrument8 Star4)
	(calibration_target instrument8 Star14)
	(on_board instrument7 satellite6)
	(on_board instrument8 satellite6)
	(power_avail satellite6)
	(pointing satellite6 GroundStation10)
	(supports instrument9 thermograph0)
	(calibration_target instrument9 GroundStation3)
	(calibration_target instrument9 Star9)
	(on_board instrument9 satellite7)
	(power_avail satellite7)
	(pointing satellite7 Star7)
)
(:goal (and
	(pointing satellite0 Star13)
	(pointing satellite1 Star6)
	(pointing satellite3 Star5)
	(have_image Phenomenon15 thermograph0)
	(have_image Phenomenon16 thermograph0)
	(have_image Phenomenon17 thermograph0)
))

)
