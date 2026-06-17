(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Phenomenon4 - direction
	Planet5 - direction
	Phenomenon6 - direction
	Planet7 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon6)
)
(:goal (and
	(pointing satellite0 GroundStation2)
	(have_image Phenomenon4 thermograph0)
	(have_image Planet5 thermograph0)
	(have_image Phenomenon6 thermograph0)
	(have_image Planet7 thermograph0)
))

)
