(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph1 - mode
	infrared2 - mode
	spectrograph0 - mode
	Star0 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation1 - direction
	Star4 - direction
	Phenomenon5 - direction
	Planet6 - direction
	Star7 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 thermograph1)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon5)
)
(:goal (and
	(have_image Star4 spectrograph0)
	(have_image Phenomenon5 spectrograph0)
	(have_image Planet6 infrared2)
	(have_image Star7 infrared2)
))

)
