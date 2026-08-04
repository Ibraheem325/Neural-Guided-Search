(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	image0 - mode
	GroundStation3 - direction
	GroundStation5 - direction
	GroundStation7 - direction
	Star10 - direction
	Star6 - direction
	Star9 - direction
	Star4 - direction
	Star1 - direction
	GroundStation0 - direction
	Star2 - direction
	Star8 - direction
	Planet11 - direction
	Star12 - direction
	Star13 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 Star6)
	(supports instrument1 image0)
	(calibration_target instrument1 Star1)
	(supports instrument2 image0)
	(calibration_target instrument2 Star8)
	(calibration_target instrument2 Star2)
	(calibration_target instrument2 GroundStation0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet11)
)
(:goal (and
	(have_image Planet11 image0)
	(have_image Star12 image0)
	(have_image Star13 image0)
))

)
