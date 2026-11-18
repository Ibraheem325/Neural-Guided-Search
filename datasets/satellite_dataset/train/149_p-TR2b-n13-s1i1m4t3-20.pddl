(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared0 - mode
	spectrograph1 - mode
	spectrograph2 - mode
	image3 - mode
	GroundStation0 - direction
	Star2 - direction
	Star1 - direction
	Star3 - direction
	Planet4 - direction
	Star5 - direction
	Star6 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 image3)
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
)
(:goal (and
	(have_image Star3 infrared0)
	(have_image Planet4 spectrograph1)
	(have_image Star5 spectrograph1)
	(have_image Star6 image3)
))

)
