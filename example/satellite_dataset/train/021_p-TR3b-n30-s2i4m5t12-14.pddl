(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	satellite1 - satellite
	instrument4 - instrument
	instrument5 - instrument
	image3 - mode
	infrared4 - mode
	image1 - mode
	infrared2 - mode
	thermograph0 - mode
	GroundStation4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	Star11 - direction
	GroundStation3 - direction
	GroundStation1 - direction
	Star9 - direction
	Star2 - direction
	GroundStation0 - direction
	Star10 - direction
	Star7 - direction
	GroundStation8 - direction
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
	(supports instrument3 thermograph0)
	(supports instrument3 image3)
	(supports instrument3 infrared2)
	(calibration_target instrument3 Star10)
	(calibration_target instrument3 GroundStation0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet13)
	(supports instrument4 thermograph0)
	(supports instrument4 infrared4)
	(supports instrument4 image1)
	(calibration_target instrument4 Star7)
	(supports instrument5 image3)
	(supports instrument5 infrared4)
	(supports instrument5 image1)
	(calibration_target instrument5 GroundStation8)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star7)
)
(:goal (and
	(pointing satellite0 GroundStation3)
	(have_image Star12 thermograph0)
	(have_image Planet13 infrared4)
	(have_image Planet14 infrared4)
	(have_image Planet15 thermograph0)
))

)
