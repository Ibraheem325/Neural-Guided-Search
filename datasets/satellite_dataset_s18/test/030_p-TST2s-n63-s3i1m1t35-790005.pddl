(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	infrared0 - mode
	Star0 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation5 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	Star9 - direction
	Star10 - direction
	Star12 - direction
	Star13 - direction
	GroundStation14 - direction
	GroundStation15 - direction
	Star17 - direction
	Star18 - direction
	GroundStation19 - direction
	Star20 - direction
	GroundStation21 - direction
	GroundStation23 - direction
	GroundStation24 - direction
	GroundStation25 - direction
	GroundStation28 - direction
	GroundStation29 - direction
	GroundStation30 - direction
	GroundStation33 - direction
	Star34 - direction
	Star26 - direction
	GroundStation27 - direction
	Star32 - direction
	Star31 - direction
	Star4 - direction
	GroundStation1 - direction
	Star16 - direction
	Star11 - direction
	Star22 - direction
	Planet35 - direction
	Planet36 - direction
	Phenomenon37 - direction
	Phenomenon38 - direction
	Star39 - direction
	Planet40 - direction
	Phenomenon41 - direction
	Star42 - direction
	Phenomenon43 - direction
	Phenomenon44 - direction
	Phenomenon45 - direction
	Phenomenon46 - direction
	Phenomenon47 - direction
	Planet48 - direction
	Phenomenon49 - direction
	Planet50 - direction
	Star51 - direction
	Star52 - direction
	Star53 - direction
	Planet54 - direction
	Planet55 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star26)
	(calibration_target instrument0 Star31)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star42)
	(supports instrument1 infrared0)
	(calibration_target instrument1 Star32)
	(calibration_target instrument1 GroundStation1)
	(calibration_target instrument1 GroundStation27)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation15)
	(supports instrument2 infrared0)
	(calibration_target instrument2 Star22)
	(calibration_target instrument2 Star11)
	(calibration_target instrument2 Star16)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 Star4)
	(calibration_target instrument2 Star31)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet54)
)
(:goal (and
	(pointing satellite0 Star4)
	(pointing satellite2 GroundStation15)
	(have_image Planet35 infrared0)
	(have_image Planet36 infrared0)
	(have_image Phenomenon37 infrared0)
	(have_image Phenomenon38 infrared0)
	(have_image Star39 infrared0)
	(have_image Planet40 infrared0)
	(have_image Phenomenon41 infrared0)
	(have_image Star42 infrared0)
	(have_image Phenomenon43 infrared0)
	(have_image Phenomenon44 infrared0)
	(have_image Phenomenon45 infrared0)
	(have_image Phenomenon46 infrared0)
	(have_image Phenomenon47 infrared0)
	(have_image Planet48 infrared0)
	(have_image Phenomenon49 infrared0)
	(have_image Planet50 infrared0)
	(have_image Star51 infrared0)
	(have_image Star52 infrared0)
	(have_image Star53 infrared0)
	(have_image Planet54 infrared0)
	(have_image Planet55 infrared0)
))

)
