(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	image0 - mode
	GroundStation1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star5 - direction
	Star0 - direction
	Star4 - direction
	Phenomenon6 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star5)
	(supports instrument1 image0)
	(calibration_target instrument1 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon6)
	(supports instrument2 image0)
	(calibration_target instrument2 Star4)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation3)
)
(:goal (and
	(have_image Phenomenon6 image0)
))

)
