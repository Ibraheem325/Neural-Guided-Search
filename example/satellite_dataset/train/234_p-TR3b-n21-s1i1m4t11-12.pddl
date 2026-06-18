(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph3 - mode
	thermograph0 - mode
	image1 - mode
	infrared2 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	Star2 - direction
	Star4 - direction
	GroundStation5 - direction
	Star7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation6 - direction
	GroundStation3 - direction
	Star11 - direction
	Star12 - direction
	Star13 - direction
	Planet14 - direction
)
(:init
	(supports instrument0 thermograph3)
	(supports instrument0 infrared2)
	(supports instrument0 image1)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 GroundStation6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star11)
)
(:goal (and
	(have_image Star11 image1)
	(have_image Star12 image1)
	(have_image Star13 thermograph0)
	(have_image Planet14 infrared2)
))

)
