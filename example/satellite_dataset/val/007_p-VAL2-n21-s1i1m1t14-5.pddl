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
	GroundStation4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star12 - direction
	GroundStation11 - direction
	GroundStation13 - direction
	Star14 - direction
	Star15 - direction
	Planet16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation13)
	(calibration_target instrument0 GroundStation11)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation2)
)
(:goal (and
	(have_image Star14 image0)
	(have_image Star15 image0)
	(have_image Planet16 image0)
	(have_image Phenomenon17 image0)
))

)
