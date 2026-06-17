(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image2 - mode
	image3 - mode
	image4 - mode
	infrared1 - mode
	infrared5 - mode
	spectrograph0 - mode
	GroundStation0 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation8 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	Star1 - direction
	GroundStation9 - direction
	GroundStation7 - direction
	Star12 - direction
	Star13 - direction
	Phenomenon14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 spectrograph0)
	(supports instrument0 image3)
	(supports instrument0 infrared5)
	(supports instrument0 infrared1)
	(supports instrument0 image4)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation10)
)
(:goal (and
	(have_image Star12 image2)
	(have_image Star12 spectrograph0)
	(have_image Star13 image2)
	(have_image Phenomenon14 image2)
	(have_image Planet15 image4)
))

)
