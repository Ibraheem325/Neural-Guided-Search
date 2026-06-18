(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph4 - mode
	thermograph0 - mode
	image2 - mode
	spectrograph1 - mode
	spectrograph3 - mode
	GroundStation1 - direction
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star0 - direction
	Planet5 - direction
	Phenomenon6 - direction
	Planet7 - direction
	Planet8 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 spectrograph1)
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph3)
	(supports instrument0 image2)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet7)
)
(:goal (and
	(pointing satellite0 Planet8)
	(have_image Planet5 thermograph4)
	(have_image Phenomenon6 thermograph4)
	(have_image Planet7 spectrograph1)
	(have_image Planet8 image2)
))

)
