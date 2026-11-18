(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph2 - mode
	infrared0 - mode
	thermograph1 - mode
	Star0 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Star5 - direction
	GroundStation1 - direction
	Star4 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	Planet9 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
)
(:goal (and
	(have_image Star6 infrared0)
	(have_image Star7 thermograph1)
	(have_image Star8 thermograph1)
	(have_image Planet9 thermograph2)
))

)
