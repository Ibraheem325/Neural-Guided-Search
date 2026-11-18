(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	GroundStation0 - direction
	Star1 - direction
	Phenomenon2 - direction
	Phenomenon3 - direction
	Phenomenon4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon2)
)
(:goal (and
	(pointing satellite0 Phenomenon3)
	(have_image Phenomenon2 thermograph0)
	(have_image Phenomenon3 thermograph0)
	(have_image Phenomenon4 thermograph0)
	(have_image Planet5 thermograph0)
))

)
