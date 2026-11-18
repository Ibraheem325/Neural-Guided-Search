(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared1 - mode
	spectrograph0 - mode
	infrared2 - mode
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation0 - direction
	Star4 - direction
	Planet5 - direction
	Star6 - direction
	Planet7 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
)
(:goal (and
	(pointing satellite0 Star1)
	(have_image Star4 spectrograph0)
	(have_image Planet5 infrared2)
	(have_image Star6 infrared2)
	(have_image Planet7 spectrograph0)
))

)
