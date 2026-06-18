(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	image3 - mode
	infrared4 - mode
	spectrograph5 - mode
	image1 - mode
	infrared2 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	Star6 - direction
	GroundStation7 - direction
	GroundStation3 - direction
	GroundStation8 - direction
	Star9 - direction
	Star10 - direction
	Phenomenon11 - direction
	Planet12 - direction
)
(:init
	(supports instrument0 infrared4)
	(supports instrument0 infrared2)
	(supports instrument0 image1)
	(supports instrument0 spectrograph5)
	(supports instrument0 image3)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 GroundStation3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star10)
)
(:goal (and
	(have_image Star9 thermograph0)
	(have_image Star10 image1)
	(have_image Star10 spectrograph5)
	(have_image Phenomenon11 spectrograph5)
	(have_image Phenomenon11 image3)
	(have_image Planet12 infrared2)
))

)
