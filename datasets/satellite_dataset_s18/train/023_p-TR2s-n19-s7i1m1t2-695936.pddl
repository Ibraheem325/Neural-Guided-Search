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
	thermograph0 - mode
	Star1 - direction
	Star0 - direction
	Planet2 - direction
	Star3 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet2)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 Star1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet2)
	(supports instrument2 thermograph0)
	(calibration_target instrument2 Star1)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet2)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 Star1)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star3)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 Star0)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star1)
	(supports instrument5 thermograph0)
	(calibration_target instrument5 Star1)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Star1)
	(supports instrument6 thermograph0)
	(calibration_target instrument6 Star0)
	(on_board instrument6 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Star0)
)
(:goal (and
	(pointing satellite1 Star0)
	(pointing satellite2 Star1)
	(pointing satellite4 Planet2)
	(pointing satellite5 Star1)
	(have_image Planet2 thermograph0)
	(have_image Star3 thermograph0)
))

)
