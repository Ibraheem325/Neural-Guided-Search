(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared3 - mode
	spectrograph0 - mode
	spectrograph2 - mode
	thermograph4 - mode
	spectrograph1 - mode
	Star0 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star1 - direction
	Planet5 - direction
	Planet6 - direction
	Planet7 - direction
	Phenomenon8 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet6)
)
(:goal (and
	(have_image Planet5 spectrograph1)
	(have_image Planet6 thermograph4)
	(have_image Planet7 spectrograph2)
	(have_image Phenomenon8 infrared3)
))

)
