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
	infrared2 - mode
	thermograph1 - mode
	infrared0 - mode
	GroundStation8 - direction
	Star10 - direction
	Star0 - direction
	Star9 - direction
	GroundStation6 - direction
	Star4 - direction
	GroundStation3 - direction
	GroundStation7 - direction
	GroundStation2 - direction
	GroundStation12 - direction
	Star5 - direction
	Star11 - direction
	Star1 - direction
	Phenomenon13 - direction
	Planet14 - direction
	Planet15 - direction
	Planet16 - direction
	Star17 - direction
	Planet18 - direction
	Planet19 - direction
	Phenomenon20 - direction
	Phenomenon21 - direction
	Phenomenon22 - direction
	Star23 - direction
	Star24 - direction
	Phenomenon25 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared2)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation3)
	(supports instrument1 infrared2)
	(supports instrument1 infrared0)
	(supports instrument1 thermograph1)
	(calibration_target instrument1 GroundStation12)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon20)
	(supports instrument2 thermograph1)
	(supports instrument2 infrared2)
	(calibration_target instrument2 GroundStation3)
	(calibration_target instrument2 GroundStation6)
	(calibration_target instrument2 Star9)
	(calibration_target instrument2 GroundStation2)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation8)
	(supports instrument3 infrared0)
	(supports instrument3 infrared2)
	(calibration_target instrument3 Star4)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Phenomenon20)
	(supports instrument4 thermograph1)
	(supports instrument4 infrared2)
	(calibration_target instrument4 GroundStation7)
	(calibration_target instrument4 GroundStation12)
	(calibration_target instrument4 GroundStation3)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star24)
	(supports instrument5 infrared2)
	(supports instrument5 thermograph1)
	(supports instrument5 infrared0)
	(calibration_target instrument5 GroundStation12)
	(calibration_target instrument5 GroundStation2)
	(calibration_target instrument5 Star11)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Star23)
	(supports instrument6 infrared2)
	(calibration_target instrument6 Star5)
	(on_board instrument6 satellite6)
	(power_avail satellite6)
	(pointing satellite6 GroundStation12)
	(supports instrument7 infrared2)
	(calibration_target instrument7 Star1)
	(calibration_target instrument7 Star11)
	(on_board instrument7 satellite7)
	(power_avail satellite7)
	(pointing satellite7 Star24)
)
(:goal (and
	(pointing satellite2 Planet18)
	(pointing satellite4 Star9)
	(pointing satellite6 Star4)
	(have_image Phenomenon13 infrared0)
	(have_image Planet14 thermograph1)
	(have_image Planet15 infrared0)
	(have_image Planet16 thermograph1)
	(have_image Star17 thermograph1)
	(have_image Planet18 thermograph1)
	(have_image Planet19 infrared2)
	(have_image Phenomenon20 infrared0)
	(have_image Phenomenon21 thermograph1)
	(have_image Phenomenon22 infrared2)
	(have_image Star23 infrared0)
	(have_image Star24 infrared0)
	(have_image Phenomenon25 thermograph1)
))

)
