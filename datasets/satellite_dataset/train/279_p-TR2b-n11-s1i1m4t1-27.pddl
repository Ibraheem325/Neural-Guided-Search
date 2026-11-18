(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	infrared1 - mode
	spectrograph0 - mode
	infrared3 - mode
	GroundStation0 - direction
	Phenomenon1 - direction
	Star2 - direction
	Phenomenon3 - direction
	Phenomenon4 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared2)
	(supports instrument0 infrared3)
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon4)
)
(:goal (and
	(have_image Phenomenon1 infrared1)
	(have_image Star2 infrared2)
	(have_image Phenomenon3 spectrograph0)
	(have_image Phenomenon4 infrared2)
))

)
