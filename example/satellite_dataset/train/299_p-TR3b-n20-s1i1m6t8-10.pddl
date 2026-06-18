(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph2 - mode
	thermograph4 - mode
	infrared5 - mode
	infrared3 - mode
	spectrograph0 - mode
	spectrograph1 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star6 - direction
	Star7 - direction
	Star5 - direction
	Star8 - direction
	Phenomenon9 - direction
	Phenomenon10 - direction
	Planet11 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared5)
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 Star5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
)
(:goal (and
	(have_image Star8 spectrograph1)
	(have_image Star8 spectrograph0)
	(have_image Phenomenon9 thermograph4)
	(have_image Phenomenon10 infrared3)
	(have_image Phenomenon10 spectrograph1)
	(have_image Planet11 spectrograph0)
))

)
