(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	image0 - mode
	Star0 - direction
	GroundStation2 - direction
	GroundStation5 - direction
	Star4 - direction
	GroundStation1 - direction
	Star6 - direction
	GroundStation3 - direction
	Star7 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 GroundStation5)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation1)
	(calibration_target instrument1 Star4)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star6)
	(supports instrument2 image0)
	(calibration_target instrument2 GroundStation3)
	(supports instrument3 image0)
	(calibration_target instrument3 GroundStation3)
	(calibration_target instrument3 Star6)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star7)
)
(:goal (and
	(pointing satellite1 GroundStation3)
	(have_image Star7 image0)
))

)
