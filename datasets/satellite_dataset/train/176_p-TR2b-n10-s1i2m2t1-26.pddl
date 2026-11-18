(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	thermograph0 - mode
	infrared1 - mode
	Star0 - direction
	Planet1 - direction
	Planet2 - direction
	Phenomenon3 - direction
	Star4 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star0)
	(supports instrument1 infrared1)
	(calibration_target instrument1 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet1)
)
(:goal (and
	(have_image Planet1 infrared1)
	(have_image Planet2 infrared1)
	(have_image Phenomenon3 infrared1)
	(have_image Star4 infrared1)
))

)
