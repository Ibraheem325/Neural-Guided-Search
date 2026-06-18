(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared4 - mode
	infrared6 - mode
	thermograph0 - mode
	image3 - mode
	spectrograph5 - mode
	image1 - mode
	infrared2 - mode
	Star2 - direction
	Star3 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	Star8 - direction
	Star10 - direction
	GroundStation11 - direction
	Star12 - direction
	Star9 - direction
	GroundStation0 - direction
	Star1 - direction
	GroundStation4 - direction
	Star13 - direction
	Planet14 - direction
	Planet15 - direction
	Planet16 - direction
)
(:init
	(supports instrument0 infrared4)
	(supports instrument0 infrared2)
	(supports instrument0 image1)
	(supports instrument0 spectrograph5)
	(supports instrument0 image3)
	(supports instrument0 thermograph0)
	(supports instrument0 infrared6)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 Star9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
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
