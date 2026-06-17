(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	infrared2 - mode
	thermograph1 - mode
	GroundStation1 - direction
	Star0 - direction
	Star2 - direction
	Star3 - direction
	Phenomenon4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 thermograph1)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon4)
)
(:goal (and
	(have_image Star2 spectrograph0)
	(have_image Star3 spectrograph0)
	(have_image Phenomenon4 spectrograph0)
	(have_image Planet5 spectrograph0)
))

)
