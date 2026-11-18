(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	image0 - mode
	Star2 - direction
	Star4 - direction
	GroundStation6 - direction
	Star7 - direction
	GroundStation5 - direction
	Star3 - direction
	GroundStation0 - direction
	GroundStation1 - direction
	Phenomenon8 - direction
	Planet9 - direction
	Phenomenon10 - direction
	Phenomenon11 - direction
	Planet12 - direction
	Star13 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 Star7)
	(supports instrument1 image0)
	(calibration_target instrument1 Star3)
	(calibration_target instrument1 GroundStation5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star13)
	(supports instrument2 image0)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 GroundStation0)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star13)
)
(:goal (and
	(have_image Phenomenon8 image0)
	(have_image Planet9 image0)
	(have_image Phenomenon10 image0)
	(have_image Phenomenon11 image0)
	(have_image Planet12 image0)
	(have_image Star13 image0)
))

)
