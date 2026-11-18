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
	infrared0 - mode
	GroundStation4 - direction
	GroundStation11 - direction
	GroundStation20 - direction
	GroundStation24 - direction
	GroundStation3 - direction
	Star6 - direction
	GroundStation22 - direction
	GroundStation25 - direction
	Star1 - direction
	Star17 - direction
	GroundStation0 - direction
	Star10 - direction
	Star14 - direction
	GroundStation5 - direction
	GroundStation18 - direction
	Star19 - direction
	GroundStation8 - direction
	GroundStation21 - direction
	GroundStation7 - direction
	GroundStation2 - direction
	Star13 - direction
	Star12 - direction
	GroundStation9 - direction
	GroundStation15 - direction
	Star23 - direction
	GroundStation16 - direction
	Star26 - direction
	Star27 - direction
	Star28 - direction
	Planet29 - direction
	Phenomenon30 - direction
	Star31 - direction
	Star32 - direction
	Phenomenon33 - direction
	Star34 - direction
	Star35 - direction
	Star36 - direction
	Planet37 - direction
	Phenomenon38 - direction
	Planet39 - direction
	Planet40 - direction
	Planet41 - direction
	Phenomenon42 - direction
	Star43 - direction
	Star44 - direction
	Star45 - direction
	Star46 - direction
	Phenomenon47 - direction
	Planet48 - direction
	Star49 - direction
	Planet50 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation16)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 GroundStation15)
	(calibration_target instrument0 GroundStation25)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon47)
	(supports instrument1 infrared0)
	(calibration_target instrument1 GroundStation21)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star14)
	(supports instrument2 infrared0)
	(calibration_target instrument2 GroundStation25)
	(calibration_target instrument2 Star1)
	(calibration_target instrument2 GroundStation22)
	(calibration_target instrument2 Star6)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation15)
	(supports instrument3 infrared0)
	(calibration_target instrument3 GroundStation5)
	(calibration_target instrument3 Star14)
	(calibration_target instrument3 Star10)
	(calibration_target instrument3 GroundStation0)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 Star17)
	(calibration_target instrument3 Star1)
	(calibration_target instrument3 Star13)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Phenomenon30)
	(supports instrument4 infrared0)
	(calibration_target instrument4 GroundStation2)
	(calibration_target instrument4 GroundStation7)
	(calibration_target instrument4 GroundStation21)
	(calibration_target instrument4 GroundStation8)
	(calibration_target instrument4 GroundStation9)
	(calibration_target instrument4 Star19)
	(calibration_target instrument4 GroundStation18)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Phenomenon38)
	(supports instrument5 infrared0)
	(calibration_target instrument5 Star13)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 GroundStation22)
	(supports instrument6 infrared0)
	(calibration_target instrument6 GroundStation9)
	(calibration_target instrument6 Star12)
	(on_board instrument6 satellite6)
	(power_avail satellite6)
	(pointing satellite6 GroundStation15)
	(supports instrument7 infrared0)
	(calibration_target instrument7 GroundStation16)
	(calibration_target instrument7 Star23)
	(calibration_target instrument7 GroundStation15)
	(on_board instrument7 satellite7)
	(power_avail satellite7)
	(pointing satellite7 GroundStation5)
)
(:goal (and
	(pointing satellite0 Planet39)
	(pointing satellite2 GroundStation16)
	(pointing satellite3 Phenomenon30)
	(pointing satellite4 Star6)
	(pointing satellite5 Star45)
	(pointing satellite6 GroundStation24)
	(have_image Star26 infrared0)
	(have_image Star27 infrared0)
	(have_image Star28 infrared0)
	(have_image Planet29 infrared0)
	(have_image Phenomenon30 infrared0)
	(have_image Star31 infrared0)
	(have_image Star32 infrared0)
	(have_image Phenomenon33 infrared0)
	(have_image Star34 infrared0)
	(have_image Star35 infrared0)
	(have_image Star36 infrared0)
	(have_image Planet37 infrared0)
	(have_image Phenomenon38 infrared0)
	(have_image Planet39 infrared0)
	(have_image Planet40 infrared0)
	(have_image Planet41 infrared0)
	(have_image Phenomenon42 infrared0)
	(have_image Star43 infrared0)
	(have_image Star44 infrared0)
	(have_image Star45 infrared0)
	(have_image Star46 infrared0)
	(have_image Phenomenon47 infrared0)
	(have_image Planet48 infrared0)
	(have_image Star49 infrared0)
	(have_image Planet50 infrared0)
))

)
