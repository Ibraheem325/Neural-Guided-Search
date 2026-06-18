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
	infrared4 - mode
	thermograph0 - mode
	infrared2 - mode
	image3 - mode
	image1 - mode
	Star10 - direction
	GroundStation1 - direction
	Star9 - direction
	Star7 - direction
	Star2 - direction
	GroundStation8 - direction
	GroundStation6 - direction
	GroundStation3 - direction
	GroundStation0 - direction
	GroundStation5 - direction
	GroundStation4 - direction
	Star11 - direction
	Star12 - direction
	Planet13 - direction
	Planet14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 image3)
	(supports instrument0 infrared2)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 Star2)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 GroundStation0)
	(calibration_target instrument1 Star9)
	(supports instrument2 image3)
	(calibration_target instrument2 Star2)
	(calibration_target instrument2 Star7)
	(calibration_target instrument2 GroundStation0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet13)
	(supports instrument3 infrared2)
	(supports instrument3 infrared4)
	(calibration_target instrument3 GroundStation6)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 GroundStation0)
	(supports instrument4 thermograph0)
	(supports instrument4 image1)
	(supports instrument4 image3)
	(calibration_target instrument4 GroundStation5)
	(calibration_target instrument4 GroundStation0)
	(calibration_target instrument4 GroundStation3)
	(supports instrument5 infrared2)
	(calibration_target instrument5 Star11)
	(calibration_target instrument5 GroundStation4)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet14)
)
(:goal (and
	(pointing satellite0 GroundStation3)
	(have_image Star12 thermograph0)
	(have_image Planet13 infrared4)
	(have_image Planet14 infrared4)
	(have_image Planet15 thermograph0)
))

)
