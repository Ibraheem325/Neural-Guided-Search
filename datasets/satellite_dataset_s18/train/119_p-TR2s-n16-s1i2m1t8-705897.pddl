(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	infrared0 - mode
	Star1 - direction
	GroundStation2 - direction
	GroundStation6 - direction
	Star7 - direction
	Star5 - direction
	GroundStation3 - direction
	Star0 - direction
	GroundStation4 - direction
	Planet8 - direction
	Planet9 - direction
	Star10 - direction
	Phenomenon11 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 Star5)
	(supports instrument1 infrared0)
	(calibration_target instrument1 GroundStation4)
	(calibration_target instrument1 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
)
(:goal (and
	(have_image Planet8 infrared0)
	(have_image Planet9 infrared0)
	(have_image Star10 infrared0)
	(have_image Phenomenon11 infrared0)
))

)
