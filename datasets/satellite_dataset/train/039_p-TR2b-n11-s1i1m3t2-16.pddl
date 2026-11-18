(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared0 - mode
	image2 - mode
	infrared1 - mode
	GroundStation0 - direction
	Star1 - direction
	Phenomenon2 - direction
	Phenomenon3 - direction
	Planet4 - direction
	Star5 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 infrared1)
	(supports instrument0 image2)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon2)
)
(:goal (and
	(pointing satellite0 Planet4)
	(have_image Phenomenon2 infrared0)
	(have_image Phenomenon3 image2)
	(have_image Planet4 infrared0)
	(have_image Star5 infrared0)
))

)
