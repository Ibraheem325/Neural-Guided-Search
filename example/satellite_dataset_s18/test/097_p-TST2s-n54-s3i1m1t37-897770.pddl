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
	Star1 - direction
	Star3 - direction
	Star5 - direction
	Star6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star11 - direction
	Star12 - direction
	GroundStation13 - direction
	Star14 - direction
	Star16 - direction
	GroundStation19 - direction
	GroundStation21 - direction
	GroundStation22 - direction
	Star23 - direction
	GroundStation24 - direction
	GroundStation25 - direction
	Star26 - direction
	GroundStation28 - direction
	GroundStation29 - direction
	GroundStation31 - direction
	Star33 - direction
	Star36 - direction
	GroundStation27 - direction
	Star15 - direction
	Star18 - direction
	Star30 - direction
	Star35 - direction
	Star20 - direction
	GroundStation34 - direction
	GroundStation4 - direction
	GroundStation17 - direction
	Star0 - direction
	Star32 - direction
	Star2 - direction
	Phenomenon37 - direction
	Planet38 - direction
	Star39 - direction
	Phenomenon40 - direction
	Planet41 - direction
	Planet42 - direction
	Planet43 - direction
	Phenomenon44 - direction
	Star45 - direction
	Star46 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star18)
	(calibration_target instrument0 Star15)
	(calibration_target instrument0 GroundStation27)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon44)
	(supports instrument1 infrared0)
	(calibration_target instrument1 Star32)
	(calibration_target instrument1 Star35)
	(calibration_target instrument1 Star30)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star1)
	(supports instrument2 infrared0)
	(calibration_target instrument2 Star2)
	(calibration_target instrument2 Star32)
	(calibration_target instrument2 Star0)
	(calibration_target instrument2 GroundStation17)
	(calibration_target instrument2 GroundStation4)
	(calibration_target instrument2 GroundStation34)
	(calibration_target instrument2 Star20)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation13)
)
(:goal (and
	(have_image Phenomenon37 infrared0)
	(have_image Planet38 infrared0)
	(have_image Star39 infrared0)
	(have_image Phenomenon40 infrared0)
	(have_image Planet41 infrared0)
	(have_image Planet42 infrared0)
	(have_image Planet43 infrared0)
	(have_image Phenomenon44 infrared0)
	(have_image Star45 infrared0)
	(have_image Star46 infrared0)
))

)
