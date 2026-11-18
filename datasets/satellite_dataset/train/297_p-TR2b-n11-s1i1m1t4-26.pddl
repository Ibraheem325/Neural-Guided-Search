(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	Star1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Star0 - direction
	Phenomenon4 - direction
	Phenomenon5 - direction
	Planet6 - direction
	Planet7 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon5)
)
(:goal (and
	(have_image Phenomenon4 thermograph0)
	(have_image Phenomenon5 thermograph0)
	(have_image Planet6 thermograph0)
	(have_image Planet7 thermograph0)
))

)
