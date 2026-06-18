(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	image6 - mode
	thermograph0 - mode
	image2 - mode
	thermograph4 - mode
	spectrograph3 - mode
	image5 - mode
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	Star4 - direction
	GroundStation5 - direction
	Star6 - direction
	GroundStation7 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	Star12 - direction
	Star0 - direction
	Planet13 - direction
	Planet14 - direction
	Planet15 - direction
	Star16 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 spectrograph3)
	(supports instrument0 thermograph4)
	(supports instrument0 image5)
	(supports instrument0 image2)
	(supports instrument0 image6)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation2)
)
(:goal (and
	(pointing satellite0 GroundStation10)
	(have_image Planet13 thermograph0)
	(have_image Planet14 spectrograph1)
	(have_image Planet15 thermograph0)
	(have_image Planet15 image5)
	(have_image Star16 spectrograph1)
))

)
