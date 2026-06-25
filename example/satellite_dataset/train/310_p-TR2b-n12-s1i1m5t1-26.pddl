(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared1 - mode
	image3 - mode
	image4 - mode
	image2 - mode
	thermograph0 - mode
	GroundStation0 - direction
	Phenomenon1 - direction
	Star2 - direction
	Phenomenon3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 image4)
	(supports instrument0 thermograph0)
	(supports instrument0 image3)
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
)
(:goal (and
	(pointing satellite0 Phenomenon3)
	(have_image Phenomenon1 image3)
	(have_image Star2 image4)
	(have_image Phenomenon3 image4)
	(have_image Planet4 image4)
))

)
