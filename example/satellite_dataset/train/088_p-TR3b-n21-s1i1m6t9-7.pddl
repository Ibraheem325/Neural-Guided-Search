(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared3 - mode
	spectrograph5 - mode
	infrared4 - mode
	spectrograph2 - mode
	thermograph1 - mode
	image0 - mode
	GroundStation2 - direction
	Star3 - direction
	Star4 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation5 - direction
	GroundStation0 - direction
	Star1 - direction
	Phenomenon9 - direction
	Star10 - direction
	Star11 - direction
	Star12 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 image0)
	(supports instrument0 thermograph1)
	(supports instrument0 spectrograph2)
	(supports instrument0 infrared4)
	(supports instrument0 spectrograph5)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 GroundStation5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation2)
)
(:goal (and
	(pointing satellite0 Star4)
	(have_image Phenomenon9 spectrograph5)
	(have_image Phenomenon9 infrared3)
	(have_image Star10 image0)
	(have_image Star10 spectrograph2)
	(have_image Star11 infrared3)
	(have_image Star12 spectrograph2)
	(have_image Star12 image0)
))

)
