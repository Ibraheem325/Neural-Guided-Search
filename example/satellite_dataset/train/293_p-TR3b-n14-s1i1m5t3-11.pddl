(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph4 - mode
	spectrograph1 - mode
	thermograph0 - mode
	image2 - mode
	spectrograph3 - mode
	Star0 - direction
	Star2 - direction
	GroundStation1 - direction
	Star3 - direction
	Planet4 - direction
	Planet5 - direction
	Planet6 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph3)
	(supports instrument0 image2)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet5)
)
(:goal (and
	(pointing satellite0 Star2)
	(have_image Star3 thermograph0)
	(have_image Planet4 image2)
	(have_image Planet5 spectrograph1)
	(have_image Planet6 spectrograph3)
))

)
