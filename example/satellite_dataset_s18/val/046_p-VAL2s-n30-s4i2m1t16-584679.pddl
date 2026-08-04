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
	infrared0 - mode
	Star2 - direction
	GroundStation3 - direction
	Star7 - direction
	GroundStation8 - direction
	Star10 - direction
	GroundStation15 - direction
	GroundStation11 - direction
	GroundStation13 - direction
	GroundStation14 - direction
	Star4 - direction
	Star9 - direction
	Star1 - direction
	Star0 - direction
	Star12 - direction
	GroundStation6 - direction
	GroundStation5 - direction
	Star16 - direction
	Planet17 - direction
	Star18 - direction
)
(:init
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 Star9)
	(supports instrument1 infrared0)
	(calibration_target instrument1 GroundStation11)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
	(supports instrument2 infrared0)
	(calibration_target instrument2 GroundStation14)
	(calibration_target instrument2 Star12)
	(calibration_target instrument2 GroundStation13)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star10)
	(supports instrument3 infrared0)
	(calibration_target instrument3 Star1)
	(calibration_target instrument3 GroundStation5)
	(calibration_target instrument3 Star9)
	(calibration_target instrument3 Star4)
	(supports instrument4 infrared0)
	(calibration_target instrument4 GroundStation6)
	(calibration_target instrument4 Star12)
	(calibration_target instrument4 Star0)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation5)
	(supports instrument5 infrared0)
	(calibration_target instrument5 GroundStation5)
	(on_board instrument5 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation3)
)
(:goal (and
	(pointing satellite0 GroundStation6)
	(pointing satellite1 GroundStation13)
	(pointing satellite2 Star1)
	(pointing satellite3 GroundStation11)
	(have_image Star16 infrared0)
	(have_image Planet17 infrared0)
	(have_image Star18 infrared0)
))

)
