(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation5 - direction
	GroundStation4 - direction
	Star0 - direction
	Phenomenon6 - direction
	Planet7 - direction
	Star8 - direction
	Phenomenon9 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 GroundStation4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon6)
)
(:goal (and
	(pointing satellite0 GroundStation4)
	(have_image Phenomenon6 image0)
	(have_image Planet7 image0)
	(have_image Star8 image0)
	(have_image Phenomenon9 image0)
))

)
