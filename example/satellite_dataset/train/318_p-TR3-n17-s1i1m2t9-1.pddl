(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image1 - mode
	thermograph0 - mode
	GroundStation0 - direction
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star4 - direction
	GroundStation7 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	Star8 - direction
	Star9 - direction
	Planet10 - direction
	Star11 - direction
	Phenomenon12 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 image1)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 GroundStation5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet10)
)
(:goal (and
	(have_image Star9 image1)
	(have_image Planet10 image1)
	(have_image Star11 thermograph0)
	(have_image Phenomenon12 thermograph0)
))

)
