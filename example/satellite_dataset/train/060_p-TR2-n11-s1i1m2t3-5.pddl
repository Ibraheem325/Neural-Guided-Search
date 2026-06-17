(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared1 - mode
	image0 - mode
	GroundStation0 - direction
	Star2 - direction
	Star1 - direction
	Star3 - direction
	Phenomenon4 - direction
	Planet5 - direction
	Planet6 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 image0)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet5)
)
(:goal (and
	(have_image Star3 image0)
	(have_image Phenomenon4 infrared1)
	(have_image Planet5 image0)
	(have_image Planet6 infrared1)
))

)
