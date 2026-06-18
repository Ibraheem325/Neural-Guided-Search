(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	image5 - mode
	image6 - mode
	spectrograph1 - mode
	image2 - mode
	thermograph4 - mode
	spectrograph3 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation5 - direction
	Star6 - direction
	GroundStation7 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	Star4 - direction
	Phenomenon12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 image6)
	(supports instrument0 spectrograph3)
	(supports instrument0 thermograph4)
	(supports instrument0 image2)
	(supports instrument0 spectrograph1)
	(supports instrument0 image5)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation2)
)
(:goal (and
	(have_image Phenomenon12 image5)
	(have_image Phenomenon12 image6)
	(have_image Phenomenon13 image6)
	(have_image Phenomenon14 image6)
	(have_image Planet15 spectrograph1)
	(have_image Planet15 thermograph4)
))

)
