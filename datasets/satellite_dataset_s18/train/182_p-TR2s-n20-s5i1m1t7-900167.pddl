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
	Star0 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation5 - direction
	GroundStation4 - direction
	Star1 - direction
	GroundStation6 - direction
	Phenomenon7 - direction
	Star8 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 GroundStation6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation2)
	(supports instrument1 infrared0)
	(calibration_target instrument1 GroundStation2)
	(calibration_target instrument1 GroundStation6)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star1)
	(supports instrument2 infrared0)
	(calibration_target instrument2 Star3)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation5)
	(supports instrument3 infrared0)
	(calibration_target instrument3 GroundStation4)
	(calibration_target instrument3 GroundStation5)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star0)
	(supports instrument4 infrared0)
	(calibration_target instrument4 GroundStation6)
	(calibration_target instrument4 Star1)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation6)
)
(:goal (and
	(pointing satellite0 GroundStation4)
	(have_image Phenomenon7 infrared0)
	(have_image Star8 infrared0)
))

)
