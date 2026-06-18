(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph5 - mode
	image3 - mode
	infrared4 - mode
	infrared2 - mode
	thermograph0 - mode
	image1 - mode
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	GroundStation7 - direction
	Star9 - direction
	GroundStation8 - direction
	Star6 - direction
	Star0 - direction
	Star10 - direction
	Phenomenon11 - direction
	Phenomenon12 - direction
	Planet13 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 thermograph0)
	(supports instrument0 infrared4)
	(supports instrument0 image1)
	(supports instrument0 image3)
	(supports instrument0 spectrograph5)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 GroundStation8)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
)
(:goal (and
	(have_image Star10 image3)
	(have_image Phenomenon11 image1)
	(have_image Phenomenon11 spectrograph5)
	(have_image Phenomenon12 infrared2)
	(have_image Planet13 thermograph0)
	(have_image Planet13 spectrograph5)
))

)
