(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	thermograph0 - mode
	GroundStation2 - direction
	GroundStation0 - direction
	Star1 - direction
	Planet3 - direction
	Planet4 - direction
	Planet5 - direction
	Planet6 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 Star1)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
)
(:goal (and
	(have_image Planet3 thermograph0)
	(have_image Planet4 thermograph0)
	(have_image Planet5 thermograph0)
	(have_image Planet6 thermograph0)
))

)
