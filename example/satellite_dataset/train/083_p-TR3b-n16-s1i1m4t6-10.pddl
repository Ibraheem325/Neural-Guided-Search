(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph2 - mode
	spectrograph1 - mode
	spectrograph0 - mode
	infrared3 - mode
	GroundStation0 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Star4 - direction
	Star5 - direction
	Star1 - direction
	Planet6 - direction
	Phenomenon7 - direction
	Planet8 - direction
	Phenomenon9 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph0)
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon9)
)
(:goal (and
	(pointing satellite0 GroundStation3)
	(have_image Planet6 spectrograph0)
	(have_image Phenomenon7 spectrograph1)
	(have_image Planet8 spectrograph2)
	(have_image Phenomenon9 spectrograph1)
))

)
