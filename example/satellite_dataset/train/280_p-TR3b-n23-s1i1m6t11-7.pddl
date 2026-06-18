(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared4 - mode
	thermograph1 - mode
	image0 - mode
	spectrograph2 - mode
	spectrograph5 - mode
	infrared3 - mode
	GroundStation0 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation5 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star9 - direction
	GroundStation10 - direction
	Star4 - direction
	Star1 - direction
	GroundStation6 - direction
	Star11 - direction
	Planet12 - direction
	Planet13 - direction
	Star14 - direction
)
(:init
	(supports instrument0 spectrograph5)
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph2)
	(supports instrument0 image0)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared4)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation6)
)
(:goal (and
	(pointing satellite0 Star4)
	(have_image Star11 infrared4)
	(have_image Star11 image0)
	(have_image Planet12 infrared4)
	(have_image Planet12 thermograph1)
	(have_image Planet13 spectrograph2)
	(have_image Star14 infrared4)
))

)
