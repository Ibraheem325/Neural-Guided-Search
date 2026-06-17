(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star7 - direction
	Star8 - direction
	GroundStation4 - direction
	Phenomenon11 - direction
	Star12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 Star7)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation10)
)
(:goal (and
	(pointing satellite0 Star8)
	(have_image Phenomenon11 image0)
	(have_image Star12 image0)
	(have_image Phenomenon13 image0)
	(have_image Phenomenon14 image0)
))

)
