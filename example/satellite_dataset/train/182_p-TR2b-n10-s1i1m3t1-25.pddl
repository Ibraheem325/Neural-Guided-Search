(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	thermograph1 - mode
	thermograph0 - mode
	GroundStation0 - direction
	Planet1 - direction
	Planet2 - direction
	Planet3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet4)
)
(:goal (and
	(have_image Planet1 thermograph0)
	(have_image Planet2 thermograph0)
	(have_image Planet3 thermograph1)
	(have_image Planet4 thermograph0)
))

)
