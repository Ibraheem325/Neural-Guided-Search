(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph2 - mode
	thermograph1 - mode
	thermograph0 - mode
	GroundStation1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star0 - direction
	Planet4 - direction
	Phenomenon5 - direction
	Planet6 - direction
	Planet7 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph1)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation3)
)
(:goal (and
	(pointing satellite0 Planet6)
	(have_image Planet4 thermograph0)
	(have_image Phenomenon5 thermograph0)
	(have_image Planet6 thermograph1)
	(have_image Planet7 thermograph2)
))

)
