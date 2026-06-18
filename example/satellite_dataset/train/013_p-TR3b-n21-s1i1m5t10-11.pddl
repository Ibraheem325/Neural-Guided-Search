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
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	Star6 - direction
	Star7 - direction
	GroundStation8 - direction
	GroundStation1 - direction
	Star0 - direction
	Star9 - direction
	Star10 - direction
	Planet11 - direction
	Phenomenon12 - direction
	Star13 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 spectrograph3)
	(supports instrument0 spectrograph1)
	(supports instrument0 thermograph4)
	(supports instrument0 image2)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star7)
)
(:goal (and
	(have_image Star10 spectrograph3)
	(have_image Planet11 spectrograph1)
	(have_image Phenomenon12 spectrograph3)
	(have_image Star13 spectrograph3)
))

)
