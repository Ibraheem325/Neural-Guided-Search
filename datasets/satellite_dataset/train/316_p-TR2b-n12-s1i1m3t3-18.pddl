(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	thermograph1 - mode
	thermograph2 - mode
	GroundStation1 - direction
	Star2 - direction
	Star0 - direction
	Planet3 - direction
	Planet4 - direction
	Star5 - direction
	Planet6 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph2)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
)
(:goal (and
	(have_image Planet3 thermograph2)
	(have_image Planet4 thermograph0)
	(have_image Star5 thermograph2)
	(have_image Planet6 thermograph0)
))

)
