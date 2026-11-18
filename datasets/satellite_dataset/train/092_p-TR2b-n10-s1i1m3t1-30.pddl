(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph1 - mode
	spectrograph2 - mode
	infrared0 - mode
	GroundStation0 - direction
	Planet1 - direction
	Phenomenon2 - direction
	Planet3 - direction
	Phenomenon4 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared0)
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
)
(:goal (and
	(have_image Planet1 thermograph1)
	(have_image Phenomenon2 infrared0)
	(have_image Planet3 infrared0)
	(have_image Phenomenon4 spectrograph2)
))

)
