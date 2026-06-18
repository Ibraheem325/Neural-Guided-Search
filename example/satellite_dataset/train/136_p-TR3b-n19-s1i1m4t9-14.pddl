(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image3 - mode
	thermograph0 - mode
	infrared2 - mode
	image1 - mode
	Star0 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star3 - direction
	GroundStation6 - direction
	GroundStation1 - direction
	Phenomenon9 - direction
	Phenomenon10 - direction
	Star11 - direction
	Phenomenon12 - direction
)
(:init
	(supports instrument0 image3)
	(supports instrument0 infrared2)
	(supports instrument0 image1)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 Star3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation7)
)
(:goal (and
	(pointing satellite0 GroundStation6)
	(have_image Phenomenon9 thermograph0)
	(have_image Phenomenon10 thermograph0)
	(have_image Star11 thermograph0)
	(have_image Phenomenon12 image1)
))

)
