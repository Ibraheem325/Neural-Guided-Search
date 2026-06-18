(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	image3 - mode
	infrared2 - mode
	image1 - mode
	infrared4 - mode
	GroundStation1 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation0 - direction
	Planet4 - direction
	Phenomenon5 - direction
	Phenomenon6 - direction
	Planet7 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 infrared4)
	(supports instrument0 image1)
	(supports instrument0 infrared2)
	(supports instrument0 image3)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
)
(:goal (and
	(have_image Planet4 image3)
	(have_image Phenomenon5 image3)
	(have_image Phenomenon6 image3)
	(have_image Planet7 image3)
))

)
