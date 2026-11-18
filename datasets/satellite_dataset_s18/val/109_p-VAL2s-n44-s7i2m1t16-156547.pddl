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
	instrument4 - instrument
	satellite3 - satellite
	instrument5 - instrument
	instrument6 - instrument
	satellite4 - satellite
	instrument7 - instrument
	satellite5 - satellite
	instrument8 - instrument
	instrument9 - instrument
	satellite6 - satellite
	instrument10 - instrument
	instrument11 - instrument
	thermograph0 - mode
	Star7 - direction
	GroundStation15 - direction
	Star1 - direction
	Star5 - direction
	Star12 - direction
	Star2 - direction
	Star9 - direction
	Star13 - direction
	GroundStation8 - direction
	Star4 - direction
	Star10 - direction
	GroundStation11 - direction
	GroundStation0 - direction
	Star3 - direction
	Star6 - direction
	Star14 - direction
	Phenomenon16 - direction
	Phenomenon17 - direction
	Planet18 - direction
	Phenomenon19 - direction
	Phenomenon20 - direction
	Star21 - direction
	Planet22 - direction
	Phenomenon23 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 Star6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation11)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 Star13)
	(calibration_target instrument1 Star3)
	(calibration_target instrument1 Star14)
	(supports instrument2 thermograph0)
	(calibration_target instrument2 Star2)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star13)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 Star12)
	(calibration_target instrument3 Star5)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 Star2)
	(calibration_target instrument4 Star10)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star5)
	(supports instrument5 thermograph0)
	(calibration_target instrument5 Star9)
	(supports instrument6 thermograph0)
	(calibration_target instrument6 Star14)
	(calibration_target instrument6 Star13)
	(calibration_target instrument6 Star4)
	(on_board instrument5 satellite3)
	(on_board instrument6 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet18)
	(supports instrument7 thermograph0)
	(calibration_target instrument7 GroundStation0)
	(calibration_target instrument7 Star4)
	(on_board instrument7 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star13)
	(supports instrument8 thermograph0)
	(calibration_target instrument8 Star14)
	(calibration_target instrument8 Star6)
	(calibration_target instrument8 GroundStation8)
	(supports instrument9 thermograph0)
	(calibration_target instrument9 Star14)
	(on_board instrument8 satellite5)
	(on_board instrument9 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Star4)
	(supports instrument10 thermograph0)
	(calibration_target instrument10 Star10)
	(calibration_target instrument10 Star4)
	(supports instrument11 thermograph0)
	(calibration_target instrument11 Star14)
	(calibration_target instrument11 Star6)
	(calibration_target instrument11 Star3)
	(calibration_target instrument11 GroundStation0)
	(calibration_target instrument11 GroundStation11)
	(on_board instrument10 satellite6)
	(on_board instrument11 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Planet22)
)
(:goal (and
	(pointing satellite6 Star14)
	(have_image Phenomenon16 thermograph0)
	(have_image Phenomenon17 thermograph0)
	(have_image Planet18 thermograph0)
	(have_image Phenomenon19 thermograph0)
	(have_image Phenomenon20 thermograph0)
	(have_image Star21 thermograph0)
	(have_image Planet22 thermograph0)
	(have_image Phenomenon23 thermograph0)
))

)
