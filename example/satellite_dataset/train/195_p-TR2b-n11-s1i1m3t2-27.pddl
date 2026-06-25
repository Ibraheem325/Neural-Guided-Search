(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	spectrograph0 - mode
	infrared1 - mode
	Star0 - direction
	GroundStation1 - direction
	Phenomenon2 - direction
	Planet3 - direction
	Phenomenon4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 infrared1)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
)
(:goal (and
	(pointing satellite0 Phenomenon4)
	(have_image Phenomenon2 infrared1)
	(have_image Planet3 infrared2)
	(have_image Phenomenon4 infrared1)
	(have_image Planet5 infrared1)
))

)
