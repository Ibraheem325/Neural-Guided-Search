(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared3 - mode
	thermograph4 - mode
	spectrograph0 - mode
	spectrograph2 - mode
	infrared5 - mode
	spectrograph1 - mode
	GroundStation0 - direction
	Star1 - direction
	Planet2 - direction
	Phenomenon3 - direction
	Star4 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared5)
	(supports instrument0 spectrograph2)
	(supports instrument0 thermograph4)
	(supports instrument0 infrared3)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon3)
)
(:goal (and
	(have_image Star1 spectrograph0)
	(have_image Planet2 spectrograph2)
	(have_image Phenomenon3 infrared3)
	(have_image Star4 infrared5)
))

)
