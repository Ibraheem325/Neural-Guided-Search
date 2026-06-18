(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph5 - mode
	infrared3 - mode
	spectrograph2 - mode
	infrared4 - mode
	image0 - mode
	thermograph1 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	Star4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation10 - direction
	Star11 - direction
	Star12 - direction
	GroundStation13 - direction
	Star9 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph5)
	(supports instrument0 thermograph1)
	(supports instrument0 image0)
	(supports instrument0 infrared4)
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 Star9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation13)
)
(:goal (and
	(have_image Phenomenon14 image0)
	(have_image Phenomenon14 thermograph1)
	(have_image Phenomenon15 infrared3)
	(have_image Phenomenon15 spectrograph2)
	(have_image Star16 spectrograph5)
	(have_image Planet17 infrared3)
))

)
