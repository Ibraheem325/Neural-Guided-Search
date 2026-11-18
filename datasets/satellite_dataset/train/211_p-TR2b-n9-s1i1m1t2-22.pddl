(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	GroundStation1 - direction
	GroundStation0 - direction
	Star2 - direction
	Phenomenon3 - direction
	Planet4 - direction
	Phenomenon5 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
)
(:goal (and
	(have_image Star2 thermograph0)
	(have_image Phenomenon3 thermograph0)
	(have_image Planet4 thermograph0)
	(have_image Phenomenon5 thermograph0)
))

)
