(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	Star0 - direction
	GroundStation2 - direction
	Star3 - direction
	Star4 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation12 - direction
	GroundStation14 - direction
	Star15 - direction
	Star16 - direction
	GroundStation17 - direction
	GroundStation18 - direction
	GroundStation20 - direction
	GroundStation21 - direction
	Star22 - direction
	Star13 - direction
	GroundStation9 - direction
	Star1 - direction
	Star8 - direction
	Star7 - direction
	Star19 - direction
	Planet23 - direction
	Planet24 - direction
	Planet25 - direction
	Star26 - direction
	Star27 - direction
	Star28 - direction
	Planet29 - direction
	Star30 - direction
	Planet31 - direction
	Planet32 - direction
	Planet33 - direction
	Phenomenon34 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star19)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 Star13)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
)
(:goal (and
	(have_image Planet23 thermograph0)
	(have_image Planet24 thermograph0)
	(have_image Planet25 thermograph0)
	(have_image Star26 thermograph0)
	(have_image Star27 thermograph0)
	(have_image Star28 thermograph0)
	(have_image Planet29 thermograph0)
	(have_image Star30 thermograph0)
	(have_image Planet31 thermograph0)
	(have_image Planet32 thermograph0)
	(have_image Planet33 thermograph0)
	(have_image Phenomenon34 thermograph0)
))

)
