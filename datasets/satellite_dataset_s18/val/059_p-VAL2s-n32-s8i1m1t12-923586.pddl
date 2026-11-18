(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	satellite5 - satellite
	instrument5 - instrument
	satellite6 - satellite
	instrument6 - instrument
	satellite7 - satellite
	instrument7 - instrument
	thermograph0 - mode
	GroundStation10 - direction
	GroundStation7 - direction
	GroundStation5 - direction
	Star6 - direction
	GroundStation2 - direction
	Star0 - direction
	Star11 - direction
	GroundStation1 - direction
	GroundStation8 - direction
	GroundStation4 - direction
	GroundStation3 - direction
	GroundStation9 - direction
	Star12 - direction
	Planet13 - direction
	Phenomenon14 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 GroundStation7)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation7)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 GroundStation5)
	(calibration_target instrument1 Star0)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation5)
	(supports instrument2 thermograph0)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 Star6)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star11)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 GroundStation1)
	(calibration_target instrument3 Star0)
	(calibration_target instrument3 GroundStation2)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star11)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 GroundStation4)
	(calibration_target instrument4 GroundStation8)
	(calibration_target instrument4 GroundStation1)
	(calibration_target instrument4 Star11)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation9)
	(supports instrument5 thermograph0)
	(calibration_target instrument5 GroundStation3)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 GroundStation2)
	(supports instrument6 thermograph0)
	(calibration_target instrument6 GroundStation3)
	(calibration_target instrument6 GroundStation4)
	(on_board instrument6 satellite6)
	(power_avail satellite6)
	(pointing satellite6 GroundStation2)
	(supports instrument7 thermograph0)
	(calibration_target instrument7 GroundStation9)
	(on_board instrument7 satellite7)
	(power_avail satellite7)
	(pointing satellite7 GroundStation3)
)
(:goal (and
	(pointing satellite0 Planet13)
	(pointing satellite1 Star0)
	(pointing satellite2 GroundStation10)
	(have_image Star12 thermograph0)
	(have_image Planet13 thermograph0)
	(have_image Phenomenon14 thermograph0)
))

)
