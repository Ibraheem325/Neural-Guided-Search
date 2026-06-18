(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	spectrograph5 - mode
	image1 - mode
	infrared6 - mode
	thermograph0 - mode
	infrared2 - mode
	image3 - mode
	infrared4 - mode
	Star2 - direction
	GroundStation7 - direction
	Star8 - direction
	Star10 - direction
	Star12 - direction
	Star9 - direction
	GroundStation0 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation11 - direction
	Star3 - direction
	Star1 - direction
	Star13 - direction
	Planet14 - direction
	Planet15 - direction
	Planet16 - direction
)
(:init
	(supports instrument0 infrared4)
	(supports instrument0 spectrograph5)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 Star9)
	(supports instrument1 image1)
	(supports instrument1 infrared2)
	(supports instrument1 image3)
	(calibration_target instrument1 GroundStation6)
	(calibration_target instrument1 GroundStation5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
	(supports instrument2 thermograph0)
	(supports instrument2 infrared6)
	(supports instrument2 infrared4)
	(calibration_target instrument2 Star1)
	(calibration_target instrument2 Star3)
	(calibration_target instrument2 GroundStation11)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation11)
)
(:goal (and
	(pointing satellite0 Star2)
	(have_image Star13 infrared4)
	(have_image Planet14 image3)
	(have_image Planet14 infrared6)
	(have_image Planet15 infrared6)
	(have_image Planet16 infrared6)
))

)
