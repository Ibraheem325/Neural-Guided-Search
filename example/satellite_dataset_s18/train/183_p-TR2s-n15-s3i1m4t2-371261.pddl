(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	infrared3 - mode
	image0 - mode
	image1 - mode
	image2 - mode
	GroundStation1 - direction
	Star0 - direction
	Planet2 - direction
	Planet3 - direction
	Phenomenon4 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
	(supports instrument1 image0)
	(supports instrument1 infrared3)
	(supports instrument1 image1)
	(calibration_target instrument1 GroundStation1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon4)
	(supports instrument2 infrared3)
	(supports instrument2 image2)
	(calibration_target instrument2 Star0)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon4)
)
(:goal (and
	(pointing satellite0 Planet3)
	(pointing satellite1 Planet2)
	(pointing satellite2 Planet2)
	(have_image Planet2 infrared3)
	(have_image Planet3 image2)
	(have_image Phenomenon4 image0)
))

)
