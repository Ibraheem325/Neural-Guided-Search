(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	thermograph1 - mode
	infrared2 - mode
	GroundStation0 - direction
	GroundStation2 - direction
	GroundStation1 - direction
	Planet3 - direction
	Star4 - direction
	Planet5 - direction
	Planet6 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 thermograph1)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
)
(:goal (and
	(have_image Planet3 infrared2)
	(have_image Star4 thermograph1)
	(have_image Planet5 thermograph0)
	(have_image Planet6 thermograph1)
))

)
