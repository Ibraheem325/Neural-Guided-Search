(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	thermograph2 - mode
	infrared1 - mode
	thermograph0 - mode
	GroundStation1 - direction
	GroundStation0 - direction
	Planet2 - direction
	Planet3 - direction
	Phenomenon4 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 GroundStation0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon4)
)
(:goal (and
	(have_image Planet2 thermograph2)
	(have_image Planet3 thermograph2)
	(have_image Phenomenon4 thermograph0)
))

)
