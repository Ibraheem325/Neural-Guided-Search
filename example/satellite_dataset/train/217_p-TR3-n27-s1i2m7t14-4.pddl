(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	image6 - mode
	infrared4 - mode
	image5 - mode
	image3 - mode
	thermograph0 - mode
	infrared1 - mode
	infrared2 - mode
	GroundStation1 - direction
	GroundStation3 - direction
	GroundStation5 - direction
	GroundStation7 - direction
	Star8 - direction
	Star9 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation0 - direction
	GroundStation12 - direction
	GroundStation13 - direction
	Star2 - direction
	Star6 - direction
	Star4 - direction
	Star14 - direction
	Planet15 - direction
	Planet16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 infrared1)
	(supports instrument0 infrared4)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 infrared1)
	(supports instrument1 thermograph0)
	(supports instrument1 image6)
	(supports instrument1 infrared2)
	(supports instrument1 image3)
	(supports instrument1 image5)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 Star6)
	(calibration_target instrument1 Star2)
	(calibration_target instrument1 GroundStation13)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet16)
)
(:goal (and
	(pointing satellite0 GroundStation7)
	(have_image Star14 image3)
	(have_image Star14 infrared2)
	(have_image Planet15 infrared4)
	(have_image Planet16 image5)
	(have_image Star17 infrared1)
	(have_image Star17 image6)
))

)
