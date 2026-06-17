(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Star6 - direction
	Star7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	GroundStation0 - direction
	Star5 - direction
	Star4 - direction
	Phenomenon10 - direction
	Planet11 - direction
	Phenomenon12 - direction
	Planet13 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon12)
)
(:goal (and
	(have_image Phenomenon10 image0)
	(have_image Planet11 image0)
	(have_image Phenomenon12 image0)
	(have_image Planet13 image0)
))

)
