(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	Star2 - direction
	GroundStation3 - direction
	Star4 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	Star8 - direction
	Star1 - direction
	Star0 - direction
	Planet9 - direction
	Phenomenon10 - direction
	Star11 - direction
	Star12 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon10)
)
(:goal (and
	(pointing satellite0 Star4)
	(have_image Planet9 thermograph0)
	(have_image Phenomenon10 thermograph0)
	(have_image Star11 thermograph0)
	(have_image Star12 thermograph0)
))

)
