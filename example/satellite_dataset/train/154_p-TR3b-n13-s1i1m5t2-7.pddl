(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared4 - mode
	thermograph1 - mode
	image0 - mode
	spectrograph2 - mode
	infrared3 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	Planet2 - direction
	Planet3 - direction
	Phenomenon4 - direction
	Phenomenon5 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph2)
	(supports instrument0 image0)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared4)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet3)
)
(:goal (and
	(have_image Planet2 image0)
	(have_image Planet3 thermograph1)
	(have_image Phenomenon4 thermograph1)
	(have_image Phenomenon5 thermograph1)
))

)
