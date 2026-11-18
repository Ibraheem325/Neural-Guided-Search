(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	infrared1 - mode
	image3 - mode
	image5 - mode
	infrared4 - mode
	thermograph0 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation6 - direction
	Star7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation4 - direction
	Star5 - direction
	Planet12 - direction
	Star13 - direction
	Planet14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 image5)
	(supports instrument0 thermograph0)
	(supports instrument0 infrared4)
	(supports instrument0 image3)
	(supports instrument0 infrared1)
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 GroundStation4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star13)
)
(:goal (and
	(have_image Planet12 infrared4)
	(have_image Planet12 image3)
	(have_image Star13 image5)
	(have_image Planet14 thermograph0)
	(have_image Planet14 infrared1)
	(have_image Phenomenon15 image5)
))

)
