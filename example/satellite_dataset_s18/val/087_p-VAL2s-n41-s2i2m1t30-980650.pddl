(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	infrared0 - mode
	Star0 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation6 - direction
	Star7 - direction
	Star8 - direction
	Star9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	Star13 - direction
	GroundStation16 - direction
	GroundStation17 - direction
	Star18 - direction
	Star19 - direction
	Star21 - direction
	GroundStation23 - direction
	Star25 - direction
	GroundStation27 - direction
	Star28 - direction
	GroundStation29 - direction
	GroundStation20 - direction
	Star22 - direction
	GroundStation15 - direction
	GroundStation24 - direction
	Star14 - direction
	Star12 - direction
	GroundStation26 - direction
	GroundStation1 - direction
	Star30 - direction
	Star31 - direction
	Planet32 - direction
	Planet33 - direction
	Phenomenon34 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation24)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 GroundStation15)
	(calibration_target instrument0 Star22)
	(calibration_target instrument0 GroundStation20)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
	(supports instrument1 infrared0)
	(calibration_target instrument1 GroundStation26)
	(calibration_target instrument1 Star12)
	(calibration_target instrument1 Star14)
	(supports instrument2 infrared0)
	(calibration_target instrument2 GroundStation1)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star13)
)
(:goal (and
	(pointing satellite1 GroundStation27)
	(have_image Star30 infrared0)
	(have_image Star31 infrared0)
	(have_image Planet32 infrared0)
	(have_image Planet33 infrared0)
	(have_image Phenomenon34 infrared0)
))

)
