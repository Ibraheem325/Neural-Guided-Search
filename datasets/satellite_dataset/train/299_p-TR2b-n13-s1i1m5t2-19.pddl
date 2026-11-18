(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image1 - mode
	infrared4 - mode
	image0 - mode
	infrared2 - mode
	infrared3 - mode
	Star1 - direction
	GroundStation0 - direction
	Planet2 - direction
	Phenomenon3 - direction
	Phenomenon4 - direction
	Star5 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 infrared2)
	(supports instrument0 image0)
	(supports instrument0 infrared4)
	(supports instrument0 image1)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
)
(:goal (and
	(have_image Planet2 infrared3)
	(have_image Phenomenon3 infrared3)
	(have_image Phenomenon4 image0)
	(have_image Star5 infrared3)
))

)
