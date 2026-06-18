(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared4 - mode
	spectrograph2 - mode
	thermograph1 - mode
	infrared3 - mode
	image0 - mode
	GroundStation0 - direction
	Phenomenon1 - direction
	Phenomenon2 - direction
	Planet3 - direction
	Phenomenon4 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 thermograph1)
	(supports instrument0 image0)
	(supports instrument0 infrared3)
	(supports instrument0 infrared4)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon1)
)
(:goal (and
	(have_image Phenomenon1 spectrograph2)
	(have_image Phenomenon2 thermograph1)
	(have_image Planet3 infrared3)
	(have_image Phenomenon4 spectrograph2)
))

)
