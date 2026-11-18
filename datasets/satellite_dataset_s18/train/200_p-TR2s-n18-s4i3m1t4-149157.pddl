(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	satellite3 - satellite
	instrument5 - instrument
	image0 - mode
	Star2 - direction
	Star1 - direction
	GroundStation3 - direction
	Star0 - direction
	Phenomenon4 - direction
	Planet5 - direction
	Star6 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star0)
	(supports instrument1 image0)
	(calibration_target instrument1 Star1)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
	(supports instrument2 image0)
	(calibration_target instrument2 GroundStation3)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star2)
	(supports instrument3 image0)
	(calibration_target instrument3 GroundStation3)
	(supports instrument4 image0)
	(calibration_target instrument4 GroundStation3)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation3)
	(supports instrument5 image0)
	(calibration_target instrument5 Star0)
	(on_board instrument5 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet5)
)
(:goal (and
	(pointing satellite1 GroundStation3)
	(pointing satellite3 Star6)
	(have_image Phenomenon4 image0)
	(have_image Planet5 image0)
	(have_image Star6 image0)
))

)
