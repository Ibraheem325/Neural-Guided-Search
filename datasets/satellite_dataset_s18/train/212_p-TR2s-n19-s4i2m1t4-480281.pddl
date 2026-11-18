(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	satellite3 - satellite
	instrument5 - instrument
	thermograph0 - mode
	GroundStation0 - direction
	GroundStation2 - direction
	GroundStation1 - direction
	Star3 - direction
	Planet4 - direction
	Star5 - direction
	Phenomenon6 - direction
	Star7 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 GroundStation1)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star7)
	(supports instrument2 thermograph0)
	(calibration_target instrument2 Star3)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 GroundStation1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon6)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 Star3)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star7)
	(supports instrument5 thermograph0)
	(calibration_target instrument5 Star3)
	(on_board instrument5 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet4)
)
(:goal (and
	(pointing satellite0 Star7)
	(have_image Planet4 thermograph0)
	(have_image Star5 thermograph0)
	(have_image Phenomenon6 thermograph0)
	(have_image Star7 thermograph0)
))

)
