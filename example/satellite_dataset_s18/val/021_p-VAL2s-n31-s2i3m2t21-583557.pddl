(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	instrument4 - instrument
	image0 - mode
	infrared1 - mode
	GroundStation0 - direction
	Star4 - direction
	Star5 - direction
	GroundStation15 - direction
	GroundStation19 - direction
	Star17 - direction
	GroundStation2 - direction
	Star13 - direction
	Star1 - direction
	Star16 - direction
	Star3 - direction
	GroundStation9 - direction
	Star6 - direction
	GroundStation10 - direction
	Star7 - direction
	Star18 - direction
	Star11 - direction
	Star12 - direction
	GroundStation14 - direction
	GroundStation8 - direction
	Star20 - direction
	Star21 - direction
)
(:init
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 Star13)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 Star17)
	(calibration_target instrument0 Star20)
	(calibration_target instrument0 GroundStation10)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation8)
	(supports instrument2 infrared1)
	(supports instrument2 image0)
	(calibration_target instrument2 GroundStation10)
	(calibration_target instrument2 Star11)
	(calibration_target instrument2 Star6)
	(calibration_target instrument2 GroundStation9)
	(calibration_target instrument2 Star3)
	(calibration_target instrument2 Star16)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star16)
	(supports instrument3 infrared1)
	(calibration_target instrument3 Star20)
	(calibration_target instrument3 GroundStation10)
	(supports instrument4 image0)
	(supports instrument4 infrared1)
	(calibration_target instrument4 Star20)
	(calibration_target instrument4 GroundStation8)
	(calibration_target instrument4 GroundStation14)
	(calibration_target instrument4 Star12)
	(calibration_target instrument4 Star11)
	(calibration_target instrument4 Star18)
	(calibration_target instrument4 Star7)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star13)
)
(:goal (and
	(pointing satellite1 Star3)
	(have_image Star21 image0)
))

)
