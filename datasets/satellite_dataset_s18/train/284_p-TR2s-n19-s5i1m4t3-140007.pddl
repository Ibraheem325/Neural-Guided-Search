(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	infrared0 - mode
	image2 - mode
	image3 - mode
	image1 - mode
	Star1 - direction
	GroundStation0 - direction
	Star2 - direction
	Star3 - direction
	Star4 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 image3)
	(supports instrument0 image2)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
	(supports instrument1 infrared0)
	(calibration_target instrument1 Star1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star4)
	(supports instrument2 image2)
	(calibration_target instrument2 Star2)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star2)
	(supports instrument3 infrared0)
	(supports instrument3 image2)
	(calibration_target instrument3 GroundStation0)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star4)
	(supports instrument4 image2)
	(supports instrument4 image1)
	(calibration_target instrument4 Star2)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star2)
)
(:goal (and
	(pointing satellite0 Star3)
	(pointing satellite1 Star3)
	(pointing satellite2 Star3)
	(have_image Star3 image3)
	(have_image Star4 image2)
))

)
