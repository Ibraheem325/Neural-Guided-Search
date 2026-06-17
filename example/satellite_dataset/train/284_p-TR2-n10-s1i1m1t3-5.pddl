(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Phenomenon3 - direction
	Phenomenon4 - direction
	Star5 - direction
	Phenomenon6 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
)
(:goal (and
	(have_image Phenomenon3 image0)
	(have_image Phenomenon4 image0)
	(have_image Star5 image0)
	(have_image Phenomenon6 image0)
))

)
