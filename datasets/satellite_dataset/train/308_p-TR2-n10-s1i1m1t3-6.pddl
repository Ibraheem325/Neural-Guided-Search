(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared0 - mode
	Star1 - direction
	GroundStation2 - direction
	GroundStation0 - direction
	Phenomenon3 - direction
	Planet4 - direction
	Phenomenon5 - direction
	Star6 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star6)
)
(:goal (and
	(have_image Phenomenon3 infrared0)
	(have_image Planet4 infrared0)
	(have_image Phenomenon5 infrared0)
	(have_image Star6 infrared0)
))

)
