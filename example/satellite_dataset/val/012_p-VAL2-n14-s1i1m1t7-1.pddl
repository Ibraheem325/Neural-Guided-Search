(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	Star0 - direction
	GroundStation3 - direction
	Star4 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation2 - direction
	GroundStation1 - direction
	Star7 - direction
	Planet8 - direction
	Phenomenon9 - direction
	Star10 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 GroundStation2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
)
(:goal (and
	(pointing satellite0 Star5)
	(have_image Star7 thermograph0)
	(have_image Planet8 thermograph0)
	(have_image Phenomenon9 thermograph0)
	(have_image Star10 thermograph0)
))

)
