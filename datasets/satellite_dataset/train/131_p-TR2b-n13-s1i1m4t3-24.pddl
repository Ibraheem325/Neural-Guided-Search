(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph3 - mode
	infrared0 - mode
	thermograph1 - mode
	infrared2 - mode
	GroundStation0 - direction
	Star1 - direction
	Star2 - direction
	Phenomenon3 - direction
	Phenomenon4 - direction
	Planet5 - direction
	Phenomenon6 - direction
)
(:init
	(supports instrument0 spectrograph3)
	(supports instrument0 infrared2)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon3)
)
(:goal (and
	(have_image Phenomenon3 spectrograph3)
	(have_image Phenomenon4 infrared0)
	(have_image Planet5 spectrograph3)
	(have_image Phenomenon6 spectrograph3)
))

)
