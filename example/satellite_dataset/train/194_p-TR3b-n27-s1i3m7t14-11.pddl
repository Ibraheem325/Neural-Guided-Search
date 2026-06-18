(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	image2 - mode
	image6 - mode
	thermograph4 - mode
	spectrograph3 - mode
	thermograph0 - mode
	image5 - mode
	spectrograph1 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	Star6 - direction
	GroundStation7 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	Star12 - direction
	GroundStation13 - direction
	GroundStation5 - direction
	Star4 - direction
	Planet14 - direction
	Planet15 - direction
	Star16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 image6)
	(supports instrument0 thermograph0)
	(supports instrument0 spectrograph3)
	(calibration_target instrument0 GroundStation13)
	(calibration_target instrument0 GroundStation5)
	(supports instrument1 image2)
	(supports instrument1 image6)
	(supports instrument1 image5)
	(calibration_target instrument1 GroundStation5)
	(supports instrument2 spectrograph1)
	(supports instrument2 thermograph4)
	(calibration_target instrument2 Star4)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
)
(:goal (and
	(have_image Planet14 spectrograph3)
	(have_image Planet15 image6)
	(have_image Star16 image5)
	(have_image Star16 image2)
	(have_image Star17 spectrograph3)
	(have_image Star17 thermograph0)
))

)
