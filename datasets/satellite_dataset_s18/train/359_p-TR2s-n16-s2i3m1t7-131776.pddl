(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	thermograph0 - mode
	Star3 - direction
	GroundStation2 - direction
	GroundStation6 - direction
	Star4 - direction
	Star1 - direction
	Star5 - direction
	Star0 - direction
	Phenomenon7 - direction
	Planet8 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 GroundStation2)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 GroundStation6)
	(supports instrument2 thermograph0)
	(calibration_target instrument2 Star0)
	(calibration_target instrument2 Star1)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 Star0)
	(calibration_target instrument3 Star5)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation2)
)
(:goal (and
	(pointing satellite1 Star4)
	(have_image Phenomenon7 thermograph0)
	(have_image Planet8 thermograph0)
))

)
