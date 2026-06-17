(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	Star1 - direction
	Star2 - direction
	Star3 - direction
	Star5 - direction
	GroundStation6 - direction
	Star7 - direction
	GroundStation8 - direction
	Star4 - direction
	GroundStation0 - direction
	Phenomenon9 - direction
	Star10 - direction
	Planet11 - direction
	Star12 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation8)
)
(:goal (and
	(pointing satellite0 Star12)
	(have_image Phenomenon9 image0)
	(have_image Star10 image0)
	(have_image Planet11 image0)
	(have_image Star12 image0)
))

)
