(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	infrared6 - mode
	image1 - mode
	thermograph0 - mode
	spectrograph5 - mode
	image3 - mode
	infrared4 - mode
	GroundStation0 - direction
	Star1 - direction
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation7 - direction
	Star8 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	Star9 - direction
	Star10 - direction
	Star11 - direction
	Phenomenon12 - direction
)
(:init
	(supports instrument0 infrared4)
	(supports instrument0 spectrograph5)
	(supports instrument0 image3)
	(supports instrument0 thermograph0)
	(supports instrument0 image1)
	(supports instrument0 infrared6)
	(supports instrument0 infrared2)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 GroundStation5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star3)
)
(:goal (and
	(have_image Star9 infrared4)
	(have_image Star10 infrared4)
	(have_image Star10 spectrograph5)
	(have_image Star11 spectrograph5)
	(have_image Star11 infrared2)
	(have_image Phenomenon12 image1)
))

)
