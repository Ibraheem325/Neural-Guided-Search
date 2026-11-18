(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image1 - mode
	infrared3 - mode
	infrared2 - mode
	image0 - mode
	GroundStation1 - direction
	GroundStation2 - direction
	Star0 - direction
	Phenomenon3 - direction
	Phenomenon4 - direction
	Phenomenon5 - direction
	Phenomenon6 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 image1)
	(supports instrument0 image0)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon6)
)
(:goal (and
	(have_image Phenomenon3 image0)
	(have_image Phenomenon4 image0)
	(have_image Phenomenon5 image0)
	(have_image Phenomenon6 image0)
))

)
