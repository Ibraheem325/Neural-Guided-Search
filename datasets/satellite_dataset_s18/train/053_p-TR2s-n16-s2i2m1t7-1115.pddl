(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	infrared0 - mode
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star6 - direction
	Star0 - direction
	Star4 - direction
	Star5 - direction
	Planet7 - direction
	Phenomenon8 - direction
	Star9 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
	(supports instrument1 infrared0)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 Star0)
	(supports instrument2 infrared0)
	(calibration_target instrument2 Star5)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet7)
)
(:goal (and
	(have_image Planet7 infrared0)
	(have_image Phenomenon8 infrared0)
	(have_image Star9 infrared0)
))

)
