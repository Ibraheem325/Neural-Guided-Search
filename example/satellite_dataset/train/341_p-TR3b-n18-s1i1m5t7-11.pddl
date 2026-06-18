(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph3 - mode
	thermograph4 - mode
	image2 - mode
	spectrograph1 - mode
	thermograph0 - mode
	Star0 - direction
	GroundStation1 - direction
	Star3 - direction
	GroundStation4 - direction
	Star6 - direction
	Star2 - direction
	GroundStation5 - direction
	Star7 - direction
	Star8 - direction
	Star9 - direction
	Phenomenon10 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 image2)
	(supports instrument0 spectrograph1)
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph3)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
)
(:goal (and
	(have_image Star7 thermograph4)
	(have_image Star8 thermograph4)
	(have_image Star9 spectrograph1)
	(have_image Phenomenon10 thermograph0)
))

)
