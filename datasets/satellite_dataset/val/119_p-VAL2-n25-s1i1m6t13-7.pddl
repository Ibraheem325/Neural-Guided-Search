(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph5 - mode
	infrared4 - mode
	thermograph1 - mode
	infrared3 - mode
	image0 - mode
	spectrograph2 - mode
	Star1 - direction
	GroundStation2 - direction
	Star4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation10 - direction
	Star11 - direction
	Star12 - direction
	Star3 - direction
	Star9 - direction
	GroundStation0 - direction
	Planet13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 infrared4)
	(supports instrument0 image0)
	(supports instrument0 infrared3)
	(supports instrument0 thermograph1)
	(supports instrument0 spectrograph5)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 Star3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star12)
)
(:goal (and
	(have_image Planet13 infrared4)
	(have_image Planet13 thermograph1)
	(have_image Phenomenon14 infrared4)
	(have_image Phenomenon15 infrared3)
	(have_image Phenomenon16 spectrograph2)
))

)
