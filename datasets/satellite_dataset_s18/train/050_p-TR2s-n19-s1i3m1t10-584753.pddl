(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	infrared0 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star7 - direction
	Star9 - direction
	GroundStation6 - direction
	Star8 - direction
	Planet10 - direction
	Phenomenon11 - direction
	Star12 - direction
	Star13 - direction
	Star14 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation6)
	(supports instrument1 infrared0)
	(calibration_target instrument1 Star8)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation3)
)
(:goal (and
	(pointing satellite0 Star1)
	(have_image Planet10 infrared0)
	(have_image Phenomenon11 infrared0)
	(have_image Star12 infrared0)
	(have_image Star13 infrared0)
	(have_image Star14 infrared0)
))

)
