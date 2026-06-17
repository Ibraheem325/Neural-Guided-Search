(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	image1 - mode
	GroundStation0 - direction
	GroundStation3 - direction
	Star4 - direction
	GroundStation5 - direction
	Star1 - direction
	Star2 - direction
	Phenomenon6 - direction
	Planet7 - direction
	Planet8 - direction
	Star9 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 image1)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation5)
)
(:goal (and
	(have_image Phenomenon6 thermograph0)
	(have_image Planet7 image1)
	(have_image Planet8 image1)
	(have_image Star9 thermograph0)
))

)
