(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	Star0 - direction
	Star1 - direction
	Star4 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation3 - direction
	Star2 - direction
	Planet7 - direction
	Planet8 - direction
	Phenomenon9 - direction
	Phenomenon10 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 GroundStation3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet7)
)
(:goal (and
	(have_image Planet7 thermograph0)
	(have_image Planet8 thermograph0)
	(have_image Phenomenon9 thermograph0)
	(have_image Phenomenon10 thermograph0)
))

)
