(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	GroundStation0 - direction
	Star1 - direction
	Star2 - direction
	Star3 - direction
	Star4 - direction
	Star5 - direction
	GroundStation6 - direction
	Star7 - direction
	GroundStation8 - direction
	GroundStation10 - direction
	Star11 - direction
	Star12 - direction
	GroundStation13 - direction
	Star9 - direction
	Star14 - direction
	Planet15 - direction
	Star16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star9)
)
(:goal (and
	(pointing satellite0 Star9)
	(have_image Star14 image0)
	(have_image Planet15 image0)
	(have_image Star16 image0)
	(have_image Star17 image0)
))

)
