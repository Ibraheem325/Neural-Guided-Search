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
	infrared3 - mode
	thermograph1 - mode
	infrared0 - mode
	infrared2 - mode
	GroundStation0 - direction
	GroundStation7 - direction
	Star15 - direction
	Star16 - direction
	GroundStation17 - direction
	Star23 - direction
	Star25 - direction
	GroundStation29 - direction
	GroundStation8 - direction
	GroundStation3 - direction
	Star22 - direction
	GroundStation26 - direction
	GroundStation19 - direction
	GroundStation24 - direction
	GroundStation11 - direction
	GroundStation18 - direction
	Star27 - direction
	GroundStation20 - direction
	GroundStation10 - direction
	GroundStation28 - direction
	Star21 - direction
	Star4 - direction
	Star12 - direction
	GroundStation2 - direction
	Star9 - direction
	GroundStation13 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation14 - direction
	GroundStation1 - direction
	Phenomenon30 - direction
	Planet31 - direction
	Phenomenon32 - direction
	Planet33 - direction
	Phenomenon34 - direction
	Phenomenon35 - direction
	Phenomenon36 - direction
	Phenomenon37 - direction
	Planet38 - direction
	Star39 - direction
	Phenomenon40 - direction
	Phenomenon41 - direction
	Star42 - direction
	Star43 - direction
	Star44 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star21)
	(calibration_target instrument0 GroundStation11)
	(calibration_target instrument0 Star12)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 GroundStation13)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 GroundStation29)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star42)
	(supports instrument1 infrared2)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 GroundStation28)
	(calibration_target instrument1 Star5)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation26)
	(supports instrument2 infrared0)
	(supports instrument2 infrared2)
	(supports instrument2 infrared3)
	(calibration_target instrument2 GroundStation20)
	(calibration_target instrument2 GroundStation11)
	(calibration_target instrument2 Star12)
	(calibration_target instrument2 GroundStation24)
	(calibration_target instrument2 GroundStation19)
	(calibration_target instrument2 GroundStation26)
	(calibration_target instrument2 Star22)
	(calibration_target instrument2 GroundStation13)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon37)
	(supports instrument3 infrared3)
	(supports instrument3 infrared0)
	(supports instrument3 infrared2)
	(calibration_target instrument3 GroundStation2)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation19)
	(supports instrument4 thermograph1)
	(supports instrument4 infrared2)
	(supports instrument4 infrared0)
	(calibration_target instrument4 GroundStation18)
	(calibration_target instrument4 Star21)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star44)
	(supports instrument5 infrared3)
	(calibration_target instrument5 Star4)
	(calibration_target instrument5 Star21)
	(calibration_target instrument5 GroundStation28)
	(calibration_target instrument5 GroundStation10)
	(calibration_target instrument5 GroundStation20)
	(calibration_target instrument5 Star27)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 GroundStation24)
	(supports instrument6 infrared0)
	(calibration_target instrument6 GroundStation1)
	(calibration_target instrument6 GroundStation14)
	(calibration_target instrument6 GroundStation6)
	(calibration_target instrument6 Star5)
	(calibration_target instrument6 GroundStation13)
	(calibration_target instrument6 Star9)
	(calibration_target instrument6 GroundStation2)
	(calibration_target instrument6 Star12)
	(on_board instrument6 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Star43)
)
(:goal (and
	(pointing satellite1 Star44)
	(pointing satellite3 GroundStation3)
	(pointing satellite5 Phenomenon34)
	(pointing satellite6 Phenomenon30)
	(have_image Phenomenon30 infrared2)
	(have_image Planet31 infrared0)
	(have_image Phenomenon32 infrared2)
	(have_image Planet33 infrared0)
	(have_image Phenomenon34 infrared2)
	(have_image Phenomenon35 infrared2)
	(have_image Phenomenon36 infrared2)
	(have_image Phenomenon37 infrared2)
	(have_image Planet38 infrared2)
	(have_image Star39 infrared2)
	(have_image Phenomenon40 thermograph1)
	(have_image Phenomenon41 infrared0)
	(have_image Star42 infrared0)
	(have_image Star43 infrared3)
	(have_image Star44 infrared3)
))

)
