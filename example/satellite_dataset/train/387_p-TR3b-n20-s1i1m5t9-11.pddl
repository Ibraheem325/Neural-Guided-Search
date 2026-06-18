(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	spectrograph3 - mode
	thermograph0 - mode
	thermograph4 - mode
	image2 - mode
	Star0 - direction
	GroundStation1 - direction
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	Star6 - direction
	GroundStation8 - direction
	Star7 - direction
	Star9 - direction
	Star10 - direction
	Planet11 - direction
	Phenomenon12 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph3)
	(supports instrument0 thermograph0)
	(supports instrument0 image2)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star7)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star10)
)
(:goal (and
	(have_image Star9 spectrograph3)
	(have_image Star10 thermograph0)
	(have_image Planet11 thermograph0)
	(have_image Phenomenon12 image2)
))

)
