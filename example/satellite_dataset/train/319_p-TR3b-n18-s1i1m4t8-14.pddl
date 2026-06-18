(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image1 - mode
	image3 - mode
	thermograph0 - mode
	infrared2 - mode
	Star0 - direction
	GroundStation1 - direction
	Star3 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation4 - direction
	GroundStation2 - direction
	Planet8 - direction
	Phenomenon9 - direction
	Star10 - direction
	Star11 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 image1)
	(supports instrument0 infrared2)
	(supports instrument0 image3)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 GroundStation4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation2)
)
(:goal (and
	(pointing satellite0 GroundStation1)
	(have_image Planet8 image3)
	(have_image Phenomenon9 thermograph0)
	(have_image Star10 thermograph0)
	(have_image Star11 thermograph0)
))

)
