(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	infrared0 - mode
	infrared1 - mode
	GroundStation3 - direction
	Star4 - direction
	GroundStation7 - direction
	GroundStation11 - direction
	Star12 - direction
	Star13 - direction
	GroundStation14 - direction
	Star15 - direction
	Star16 - direction
	Star18 - direction
	Star19 - direction
	Star20 - direction
	GroundStation21 - direction
	Star23 - direction
	Star5 - direction
	Star24 - direction
	Star26 - direction
	GroundStation1 - direction
	GroundStation6 - direction
	GroundStation17 - direction
	GroundStation22 - direction
	Star9 - direction
	GroundStation28 - direction
	Star0 - direction
	GroundStation8 - direction
	GroundStation27 - direction
	Star10 - direction
	GroundStation2 - direction
	GroundStation25 - direction
	Star29 - direction
	Star30 - direction
)
(:init
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 Star26)
	(calibration_target instrument0 Star24)
	(calibration_target instrument0 GroundStation22)
	(calibration_target instrument0 Star5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation11)
	(supports instrument1 infrared1)
	(calibration_target instrument1 GroundStation28)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 GroundStation22)
	(calibration_target instrument1 GroundStation17)
	(calibration_target instrument1 GroundStation6)
	(supports instrument2 infrared1)
	(supports instrument2 infrared0)
	(calibration_target instrument2 GroundStation25)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 Star10)
	(calibration_target instrument2 GroundStation27)
	(calibration_target instrument2 GroundStation8)
	(calibration_target instrument2 Star0)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation22)
)
(:goal (and
	(have_image Star29 infrared0)
	(have_image Star30 infrared0)
))

)
