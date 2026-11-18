(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	image0 - mode
	GroundStation0 - direction
	Star1 - direction
	Planet2 - direction
	Phenomenon3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet4)
)
(:goal (and
	(have_image Star1 image0)
	(have_image Planet2 image0)
	(have_image Phenomenon3 image0)
	(have_image Planet4 image0)
))

)
