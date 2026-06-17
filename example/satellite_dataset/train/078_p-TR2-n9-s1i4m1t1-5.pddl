(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	image0 - mode
	Star0 - direction
	Star1 - direction
	Planet2 - direction
	Phenomenon3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star0)
	(supports instrument1 image0)
	(calibration_target instrument1 Star0)
	(supports instrument2 image0)
	(calibration_target instrument2 Star0)
	(supports instrument3 image0)
	(calibration_target instrument3 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
)
(:goal (and
	(pointing satellite0 Phenomenon3)
	(have_image Star1 image0)
	(have_image Planet2 image0)
	(have_image Phenomenon3 image0)
	(have_image Planet4 image0)
))

)
