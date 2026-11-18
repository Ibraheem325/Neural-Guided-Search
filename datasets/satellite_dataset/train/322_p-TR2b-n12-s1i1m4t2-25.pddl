(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	infrared2 - mode
	thermograph1 - mode
	thermograph3 - mode
	Star0 - direction
	GroundStation1 - direction
	Planet2 - direction
	Planet3 - direction
	Star4 - direction
	Star5 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph1)
	(supports instrument0 thermograph3)
	(supports instrument0 infrared2)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet2)
)
(:goal (and
	(have_image Planet2 infrared2)
	(have_image Planet3 infrared2)
	(have_image Star4 infrared2)
	(have_image Star5 infrared2)
))

)
