(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	infrared4 - mode
	infrared2 - mode
	thermograph0 - mode
	image1 - mode
	image3 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	Star12 - direction
	GroundStation13 - direction
	GroundStation8 - direction
	GroundStation5 - direction
	GroundStation3 - direction
	Star10 - direction
	Star11 - direction
	Star7 - direction
	Star9 - direction
	Phenomenon14 - direction
	Planet15 - direction
	Star16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 thermograph0)
	(supports instrument0 infrared4)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 GroundStation8)
	(supports instrument1 image3)
	(supports instrument1 infrared2)
	(calibration_target instrument1 Star11)
	(calibration_target instrument1 GroundStation3)
	(supports instrument2 image1)
	(supports instrument2 infrared4)
	(supports instrument2 thermograph0)
	(calibration_target instrument2 Star9)
	(calibration_target instrument2 Star7)
	(calibration_target instrument2 Star11)
	(calibration_target instrument2 Star10)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
)
(:goal (and
	(pointing satellite0 GroundStation6)
	(have_image Phenomenon14 image3)
	(have_image Planet15 image3)
	(have_image Star16 thermograph0)
	(have_image Star17 infrared2)
))

)
