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
	infrared0 - mode
	Star0 - direction
	GroundStation3 - direction
	Star5 - direction
	Star10 - direction
	Star11 - direction
	Star12 - direction
	GroundStation17 - direction
	GroundStation1 - direction
	Star16 - direction
	Star13 - direction
	GroundStation15 - direction
	Star14 - direction
	Star8 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	GroundStation9 - direction
	GroundStation7 - direction
	Star2 - direction
	Planet18 - direction
	Star19 - direction
	Planet20 - direction
	Star21 - direction
	Phenomenon22 - direction
	Star23 - direction
	Star24 - direction
	Planet25 - direction
	Planet26 - direction
	Planet27 - direction
	Planet28 - direction
	Planet29 - direction
	Star30 - direction
	Phenomenon31 - direction
	Phenomenon32 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 Star13)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 Star16)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet26)
	(supports instrument1 infrared0)
	(calibration_target instrument1 GroundStation15)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star24)
	(supports instrument2 infrared0)
	(calibration_target instrument2 Star8)
	(calibration_target instrument2 GroundStation9)
	(calibration_target instrument2 Star14)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star11)
	(supports instrument3 infrared0)
	(calibration_target instrument3 Star2)
	(calibration_target instrument3 GroundStation7)
	(calibration_target instrument3 GroundStation9)
	(calibration_target instrument3 GroundStation6)
	(calibration_target instrument3 GroundStation4)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation9)
)
(:goal (and
	(pointing satellite1 Phenomenon22)
	(pointing satellite3 GroundStation7)
	(have_image Planet18 infrared0)
	(have_image Star19 infrared0)
	(have_image Planet20 infrared0)
	(have_image Star21 infrared0)
	(have_image Phenomenon22 infrared0)
	(have_image Star23 infrared0)
	(have_image Star24 infrared0)
	(have_image Planet25 infrared0)
	(have_image Planet26 infrared0)
	(have_image Planet27 infrared0)
	(have_image Planet28 infrared0)
	(have_image Planet29 infrared0)
	(have_image Star30 infrared0)
	(have_image Phenomenon31 infrared0)
	(have_image Phenomenon32 infrared0)
))

)
