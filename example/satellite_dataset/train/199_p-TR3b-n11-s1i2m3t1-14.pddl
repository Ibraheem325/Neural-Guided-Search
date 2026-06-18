(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	image1 - mode
	infrared2 - mode
	Star0 - direction
	Star1 - direction
	Phenomenon2 - direction
	Planet3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 image1)
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet4)
)
(:goal (and
	(have_image Star1 infrared2)
	(have_image Phenomenon2 thermograph0)
	(have_image Planet3 infrared2)
	(have_image Planet4 infrared2)
))

)
