(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	image2 - mode
	spectrograph1 - mode
	thermograph0 - mode
	GroundStation0 - direction
	Phenomenon1 - direction
	Planet2 - direction
	Phenomenon3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 image2)
	(supports instrument1 spectrograph1)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 GroundStation0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon1)
)
(:goal (and
	(have_image Phenomenon1 image2)
	(have_image Planet2 spectrograph1)
	(have_image Phenomenon3 thermograph0)
	(have_image Planet4 spectrograph1)
))

)
