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
	satellite5 - satellite
	instrument5 - instrument
	infrared0 - mode
	GroundStation2 - direction
	Star3 - direction
	Star0 - direction
	Star1 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	Planet7 - direction
	Star8 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
	(supports instrument1 infrared0)
	(calibration_target instrument1 Star3)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star8)
	(supports instrument2 infrared0)
	(calibration_target instrument2 Star0)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star5)
	(supports instrument3 infrared0)
	(calibration_target instrument3 Star1)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star8)
	(supports instrument4 infrared0)
	(calibration_target instrument4 Star1)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation4)
	(supports instrument5 infrared0)
	(calibration_target instrument5 GroundStation4)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Planet7)
)
(:goal (and
	(pointing satellite4 GroundStation4)
	(have_image Star5 infrared0)
	(have_image Star6 infrared0)
	(have_image Planet7 infrared0)
	(have_image Star8 infrared0)
))

)
