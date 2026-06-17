(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	infrared1 - mode
	Star0 - direction
	GroundStation2 - direction
	Star3 - direction
	Star4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	Star1 - direction
	Phenomenon7 - direction
	Phenomenon8 - direction
	Star9 - direction
	Planet10 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
)
(:goal (and
	(have_image Phenomenon7 thermograph0)
	(have_image Phenomenon8 thermograph0)
	(have_image Star9 thermograph0)
	(have_image Planet10 infrared1)
))

)
