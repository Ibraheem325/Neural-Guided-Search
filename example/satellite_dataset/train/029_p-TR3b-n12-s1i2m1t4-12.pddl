(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	thermograph0 - mode
	Star0 - direction
	Star2 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	Star4 - direction
	Planet5 - direction
	Planet6 - direction
	Star7 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 GroundStation3)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
)
(:goal (and
	(pointing satellite0 GroundStation1)
	(have_image Star4 thermograph0)
	(have_image Planet5 thermograph0)
	(have_image Planet6 thermograph0)
	(have_image Star7 thermograph0)
))

)
