(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	thermograph0 - mode
	image1 - mode
	image3 - mode
	infrared4 - mode
	GroundStation0 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	Star7 - direction
	GroundStation8 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	Star2 - direction
	Star9 - direction
	Planet10 - direction
	Planet11 - direction
	Star12 - direction
)
(:init
	(supports instrument0 image3)
	(supports instrument0 thermograph0)
	(supports instrument0 infrared4)
	(supports instrument0 image1)
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
)
(:goal (and
	(pointing satellite0 GroundStation3)
	(have_image Star9 image1)
	(have_image Planet10 infrared2)
	(have_image Planet11 image1)
	(have_image Star12 infrared4)
))

)
