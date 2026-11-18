(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	instrument3 - instrument
	image0 - mode
	Star6 - direction
	GroundStation7 - direction
	GroundStation4 - direction
	Star1 - direction
	GroundStation0 - direction
	Star5 - direction
	GroundStation2 - direction
	Star3 - direction
	Planet8 - direction
	Star9 - direction
	Planet10 - direction
	Planet11 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 GroundStation4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet8)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation0)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet8)
	(supports instrument2 image0)
	(calibration_target instrument2 Star5)
	(supports instrument3 image0)
	(calibration_target instrument3 Star3)
	(calibration_target instrument3 GroundStation2)
	(on_board instrument2 satellite2)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation0)
)
(:goal (and
	(have_image Planet8 image0)
	(have_image Star9 image0)
	(have_image Planet10 image0)
	(have_image Planet11 image0)
))

)
