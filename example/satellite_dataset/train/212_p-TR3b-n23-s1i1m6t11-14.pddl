(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	spectrograph5 - mode
	image3 - mode
	image1 - mode
	infrared2 - mode
	infrared4 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	Star6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star10 - direction
	Star9 - direction
	Star11 - direction
	Star12 - direction
	Phenomenon13 - direction
	Planet14 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 infrared4)
	(supports instrument0 image1)
	(supports instrument0 image3)
	(supports instrument0 spectrograph5)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star9)
)
(:goal (and
	(have_image Star11 image1)
	(have_image Star11 image3)
	(have_image Star12 infrared2)
	(have_image Phenomenon13 spectrograph5)
	(have_image Phenomenon13 infrared2)
	(have_image Planet14 image3)
	(have_image Planet14 thermograph0)
))

)
