(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image2 - mode
	thermograph4 - mode
	thermograph0 - mode
	spectrograph3 - mode
	spectrograph1 - mode
	Star0 - direction
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	Star7 - direction
	GroundStation8 - direction
	Star9 - direction
	Star10 - direction
	Star11 - direction
	Star6 - direction
	GroundStation1 - direction
	Star12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph3)
	(supports instrument0 spectrograph1)
	(supports instrument0 thermograph0)
	(supports instrument0 image2)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 Star6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star11)
)
(:goal (and
	(have_image Star12 image2)
	(have_image Phenomenon13 image2)
	(have_image Phenomenon14 image2)
	(have_image Planet15 thermograph4)
))

)
