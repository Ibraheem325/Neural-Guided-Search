(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	GroundStation0 - direction
	GroundStation3 - direction
	Star4 - direction
	Star6 - direction
	Star7 - direction
	GroundStation8 - direction
	Star5 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	Planet9 - direction
	Planet10 - direction
	Star11 - direction
	Phenomenon12 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 Star5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star7)
)
(:goal (and
	(pointing satellite0 Planet9)
	(have_image Planet9 image0)
	(have_image Planet10 image0)
	(have_image Star11 image0)
	(have_image Phenomenon12 image0)
))

)
