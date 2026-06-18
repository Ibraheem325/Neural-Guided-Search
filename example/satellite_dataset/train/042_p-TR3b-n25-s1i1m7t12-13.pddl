(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared6 - mode
	spectrograph0 - mode
	image1 - mode
	infrared3 - mode
	image5 - mode
	thermograph2 - mode
	spectrograph4 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation8 - direction
	Star9 - direction
	GroundStation10 - direction
	Star11 - direction
	Star3 - direction
	GroundStation7 - direction
	Star4 - direction
	Phenomenon12 - direction
	Planet13 - direction
	Planet14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 image5)
	(supports instrument0 spectrograph4)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared3)
	(supports instrument0 image1)
	(supports instrument0 infrared6)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 Star3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star11)
)
(:goal (and
	(have_image Phenomenon12 thermograph2)
	(have_image Planet13 thermograph2)
	(have_image Planet13 infrared6)
	(have_image Planet14 image5)
	(have_image Planet14 spectrograph0)
	(have_image Planet15 infrared3)
))

)
