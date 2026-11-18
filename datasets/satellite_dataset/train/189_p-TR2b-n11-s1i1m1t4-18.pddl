(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	GroundStation0 - direction
	Star2 - direction
	Star3 - direction
	GroundStation1 - direction
	Star4 - direction
	Planet5 - direction
	Phenomenon6 - direction
	Phenomenon7 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
)
(:goal (and
	(have_image Star4 thermograph0)
	(have_image Planet5 thermograph0)
	(have_image Phenomenon6 thermograph0)
	(have_image Phenomenon7 thermograph0)
))

)
