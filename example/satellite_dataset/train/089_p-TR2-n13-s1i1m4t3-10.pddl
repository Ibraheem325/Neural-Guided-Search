(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	spectrograph2 - mode
	spectrograph0 - mode
	infrared3 - mode
	GroundStation0 - direction
	GroundStation2 - direction
	Star1 - direction
	Phenomenon3 - direction
	Star4 - direction
	Planet5 - direction
	Star6 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph0)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation2)
)
(:goal (and
	(have_image Phenomenon3 infrared3)
	(have_image Star4 spectrograph0)
	(have_image Planet5 spectrograph1)
	(have_image Star6 spectrograph0)
))

)
