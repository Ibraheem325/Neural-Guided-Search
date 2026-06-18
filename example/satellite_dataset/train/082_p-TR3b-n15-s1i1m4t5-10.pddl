(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	spectrograph0 - mode
	spectrograph2 - mode
	infrared3 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Star4 - direction
	Star5 - direction
	Planet6 - direction
	Star7 - direction
	Phenomenon8 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
)
(:goal (and
	(pointing satellite0 GroundStation0)
	(have_image Star5 spectrograph1)
	(have_image Planet6 infrared3)
	(have_image Star7 infrared3)
	(have_image Phenomenon8 spectrograph1)
))

)
