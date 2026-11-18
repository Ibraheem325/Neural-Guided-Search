(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	image5 - mode
	image6 - mode
	infrared4 - mode
	infrared1 - mode
	thermograph0 - mode
	image3 - mode
	infrared2 - mode
	Star2 - direction
	GroundStation3 - direction
	Star6 - direction
	GroundStation7 - direction
	Star8 - direction
	GroundStation12 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation1 - direction
	Star9 - direction
	Star4 - direction
	GroundStation0 - direction
	GroundStation5 - direction
	Planet13 - direction
	Phenomenon14 - direction
	Star15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 image3)
	(supports instrument0 image5)
	(calibration_target instrument0 GroundStation5)
	(supports instrument1 infrared4)
	(supports instrument1 image6)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 GroundStation1)
	(calibration_target instrument1 Star11)
	(calibration_target instrument1 GroundStation10)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation5)
	(supports instrument2 thermograph0)
	(calibration_target instrument2 Star4)
	(calibration_target instrument2 Star9)
	(supports instrument3 infrared1)
	(supports instrument3 infrared2)
	(calibration_target instrument3 GroundStation5)
	(calibration_target instrument3 GroundStation0)
	(calibration_target instrument3 Star4)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet13)
)
(:goal (and
	(have_image Planet13 infrared2)
	(have_image Phenomenon14 image3)
	(have_image Phenomenon14 thermograph0)
	(have_image Star15 image5)
	(have_image Star15 infrared1)
	(have_image Phenomenon16 thermograph0)
))

)
