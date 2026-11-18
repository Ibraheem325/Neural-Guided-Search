(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	infrared0 - mode
	GroundStation0 - direction
	Star2 - direction
	Star3 - direction
	Star4 - direction
	Star1 - direction
	Phenomenon5 - direction
	Star6 - direction
	Star7 - direction
	Planet8 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
)
(:goal (and
	(have_image Phenomenon5 spectrograph1)
	(have_image Star6 infrared0)
	(have_image Star7 spectrograph1)
	(have_image Planet8 spectrograph1)
))

)
