(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	image1 - mode
	thermograph2 - mode
	GroundStation0 - direction
	Star1 - direction
	Phenomenon2 - direction
	Planet3 - direction
	Planet4 - direction
	Phenomenon5 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 thermograph2)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
)
(:goal (and
	(have_image Phenomenon2 image1)
	(have_image Planet3 thermograph2)
	(have_image Planet4 thermograph2)
	(have_image Phenomenon5 image1)
))

)
