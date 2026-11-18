(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	infrared0 - mode
	spectrograph1 - mode
	Star0 - direction
	GroundStation1 - direction
	Planet2 - direction
	Star3 - direction
	Star4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared0)
	(supports instrument0 infrared2)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star3)
)
(:goal (and
	(pointing satellite0 Star4)
	(have_image Planet2 infrared2)
	(have_image Star3 infrared0)
	(have_image Star4 spectrograph1)
	(have_image Planet5 infrared2)
))

)
