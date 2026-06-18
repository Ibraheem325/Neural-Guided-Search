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
	instrument5 - instrument
	image1 - mode
	thermograph3 - mode
	thermograph0 - mode
	infrared2 - mode
	GroundStation3 - direction
	GroundStation6 - direction
	Star7 - direction
	Star4 - direction
	Star12 - direction
	GroundStation10 - direction
	Star13 - direction
	GroundStation9 - direction
	Star11 - direction
	GroundStation8 - direction
	GroundStation0 - direction
	GroundStation5 - direction
	GroundStation1 - direction
	Star2 - direction
	Phenomenon14 - direction
	Star15 - direction
	Phenomenon16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 thermograph3)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 GroundStation5)
	(supports instrument1 thermograph3)
	(calibration_target instrument1 GroundStation5)
	(calibration_target instrument1 Star12)
	(supports instrument2 infrared2)
	(calibration_target instrument2 GroundStation5)
	(calibration_target instrument2 GroundStation10)
	(calibration_target instrument2 GroundStation0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation10)
	(supports instrument3 thermograph0)
	(supports instrument3 image1)
	(calibration_target instrument3 GroundStation9)
	(calibration_target instrument3 Star13)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 GroundStation5)
	(supports instrument4 thermograph3)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 GroundStation5)
	(calibration_target instrument4 GroundStation0)
	(calibration_target instrument4 GroundStation8)
	(calibration_target instrument4 Star11)
	(supports instrument5 thermograph3)
	(supports instrument5 image1)
	(calibration_target instrument5 Star2)
	(calibration_target instrument5 GroundStation1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation8)
)
(:goal (and
	(pointing satellite1 Star12)
	(have_image Phenomenon14 infrared2)
	(have_image Star15 infrared2)
	(have_image Phenomenon16 thermograph3)
	(have_image Phenomenon17 infrared2)
))

)
