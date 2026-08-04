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
	thermograph1 - mode
	thermograph0 - mode
	GroundStation9 - direction
	GroundStation17 - direction
	Star4 - direction
	GroundStation0 - direction
	GroundStation7 - direction
	Star5 - direction
	Star10 - direction
	GroundStation16 - direction
	GroundStation2 - direction
	GroundStation19 - direction
	GroundStation6 - direction
	GroundStation3 - direction
	Star20 - direction
	Star18 - direction
	GroundStation14 - direction
	Star13 - direction
	GroundStation15 - direction
	Star11 - direction
	Star1 - direction
	GroundStation8 - direction
	GroundStation22 - direction
	Star12 - direction
	Star21 - direction
	Phenomenon23 - direction
	Star24 - direction
	Phenomenon25 - direction
	Star26 - direction
	Phenomenon27 - direction
	Phenomenon28 - direction
	Star29 - direction
	Star30 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 Star10)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star11)
	(supports instrument1 thermograph1)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 Star13)
	(calibration_target instrument1 GroundStation15)
	(calibration_target instrument1 Star5)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star10)
	(supports instrument2 thermograph0)
	(calibration_target instrument2 GroundStation16)
	(calibration_target instrument2 Star10)
	(supports instrument3 thermograph0)
	(supports instrument3 thermograph1)
	(calibration_target instrument3 GroundStation6)
	(calibration_target instrument3 Star12)
	(calibration_target instrument3 GroundStation19)
	(calibration_target instrument3 GroundStation2)
	(calibration_target instrument3 GroundStation22)
	(calibration_target instrument3 Star18)
	(calibration_target instrument3 Star21)
	(on_board instrument2 satellite2)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation22)
	(supports instrument4 thermograph1)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 Star20)
	(calibration_target instrument4 GroundStation3)
	(calibration_target instrument4 Star1)
	(on_board instrument4 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star1)
	(supports instrument5 thermograph1)
	(supports instrument5 thermograph0)
	(calibration_target instrument5 Star11)
	(on_board instrument5 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star18)
	(supports instrument6 thermograph1)
	(calibration_target instrument6 Star21)
	(calibration_target instrument6 Star11)
	(calibration_target instrument6 GroundStation14)
	(calibration_target instrument6 Star18)
	(calibration_target instrument6 Star20)
	(calibration_target instrument6 GroundStation3)
	(on_board instrument6 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Star24)
	(supports instrument7 thermograph1)
	(supports instrument7 thermograph0)
	(calibration_target instrument7 Star12)
	(calibration_target instrument7 GroundStation22)
	(calibration_target instrument7 GroundStation8)
	(calibration_target instrument7 Star1)
	(calibration_target instrument7 Star11)
	(calibration_target instrument7 GroundStation15)
	(calibration_target instrument7 Star13)
	(supports instrument8 thermograph0)
	(supports instrument8 thermograph1)
	(calibration_target instrument8 Star21)
	(on_board instrument7 satellite6)
	(on_board instrument8 satellite6)
	(power_avail satellite6)
	(pointing satellite6 GroundStation8)
)
(:goal (and
	(pointing satellite1 Star11)
	(pointing satellite3 GroundStation6)
	(pointing satellite4 Star18)
	(pointing satellite5 Phenomenon23)
	(have_image Phenomenon23 thermograph0)
	(have_image Star24 thermograph1)
	(have_image Phenomenon25 thermograph0)
	(have_image Star26 thermograph1)
	(have_image Phenomenon27 thermograph0)
	(have_image Phenomenon28 thermograph0)
	(have_image Star29 thermograph0)
	(have_image Star30 thermograph1)
))

)
