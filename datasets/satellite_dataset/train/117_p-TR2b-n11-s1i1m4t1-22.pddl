(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared3 - mode
	spectrograph2 - mode
	spectrograph1 - mode
	thermograph0 - mode
	GroundStation0 - direction
	Phenomenon1 - direction
	Star2 - direction
	Planet3 - direction
	Phenomenon4 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon1)
)
(:goal (and
	(have_image Phenomenon1 spectrograph1)
	(have_image Star2 thermograph0)
	(have_image Planet3 spectrograph1)
	(have_image Phenomenon4 spectrograph2)
))

)
