(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph1 - mode
	infrared0 - mode
	Star1 - direction
	Star0 - direction
	Star2 - direction
	Planet3 - direction
	Phenomenon4 - direction
	Star5 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(have_image Star2 infrared0)
	(have_image Planet3 thermograph1)
	(have_image Phenomenon4 infrared0)
	(have_image Star5 infrared0)
))

)
