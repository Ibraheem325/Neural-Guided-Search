(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared3 - mode
	spectrograph4 - mode
	thermograph0 - mode
	spectrograph2 - mode
	spectrograph1 - mode
	GroundStation0 - direction
	Star1 - direction
	Star2 - direction
	Planet3 - direction
	Planet4 - direction
	Phenomenon5 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph4)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
)
(:goal (and
	(pointing satellite0 Star2)
	(have_image Star2 spectrograph2)
	(have_image Planet3 spectrograph4)
	(have_image Planet4 spectrograph1)
	(have_image Phenomenon5 spectrograph1)
))

)
