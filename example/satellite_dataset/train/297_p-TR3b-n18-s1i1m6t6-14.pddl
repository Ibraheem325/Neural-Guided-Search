(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph5 - mode
	image1 - mode
	infrared2 - mode
	infrared4 - mode
	thermograph0 - mode
	image3 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation5 - direction
	GroundStation4 - direction
	Phenomenon6 - direction
	Star7 - direction
	Phenomenon8 - direction
	Phenomenon9 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 image3)
	(supports instrument0 thermograph0)
	(supports instrument0 infrared4)
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph5)
	(calibration_target instrument0 GroundStation4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(have_image Phenomenon6 image3)
	(have_image Phenomenon6 thermograph0)
	(have_image Star7 infrared4)
	(have_image Phenomenon8 infrared2)
	(have_image Phenomenon9 infrared4)
	(have_image Phenomenon9 infrared2)
))

)
