(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph3 - mode
	image1 - mode
	thermograph0 - mode
	thermograph2 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	Phenomenon2 - direction
	Phenomenon3 - direction
	Phenomenon4 - direction
	Star5 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph2)
	(supports instrument0 image1)
	(supports instrument0 thermograph3)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
)
(:goal (and
	(have_image Phenomenon2 thermograph3)
	(have_image Phenomenon3 thermograph0)
	(have_image Phenomenon4 thermograph2)
	(have_image Star5 image1)
))

)
