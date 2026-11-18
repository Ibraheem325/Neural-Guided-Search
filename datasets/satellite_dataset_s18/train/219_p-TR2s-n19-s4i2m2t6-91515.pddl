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
	instrument4 - instrument
	infrared0 - mode
	infrared1 - mode
	Star5 - direction
	GroundStation2 - direction
	Star4 - direction
	Star0 - direction
	GroundStation3 - direction
	Star1 - direction
	Star6 - direction
	Planet7 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star6)
	(supports instrument1 infrared0)
	(supports instrument1 infrared1)
	(calibration_target instrument1 Star4)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet7)
	(supports instrument2 infrared0)
	(supports instrument2 infrared1)
	(calibration_target instrument2 Star0)
	(calibration_target instrument2 Star4)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet7)
	(supports instrument3 infrared0)
	(calibration_target instrument3 GroundStation3)
	(supports instrument4 infrared1)
	(calibration_target instrument4 Star1)
	(calibration_target instrument4 GroundStation3)
	(on_board instrument3 satellite3)
	(on_board instrument4 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star4)
)
(:goal (and
	(pointing satellite2 GroundStation2)
	(pointing satellite3 Star5)
	(have_image Star6 infrared1)
	(have_image Planet7 infrared1)
))

)
