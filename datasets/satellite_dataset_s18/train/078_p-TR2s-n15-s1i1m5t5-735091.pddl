(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared3 - mode
	spectrograph2 - mode
	spectrograph1 - mode
	spectrograph0 - mode
	spectrograph4 - mode
	GroundStation0 - direction
	Star2 - direction
	GroundStation3 - direction
	Star4 - direction
	Star1 - direction
	Planet5 - direction
	Phenomenon6 - direction
	Star7 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph4)
	(supports instrument0 spectrograph0)
	(supports instrument0 spectrograph2)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
)
(:goal (and
	(have_image Planet5 spectrograph1)
	(have_image Phenomenon6 infrared3)
	(have_image Star7 spectrograph1)
))

)
