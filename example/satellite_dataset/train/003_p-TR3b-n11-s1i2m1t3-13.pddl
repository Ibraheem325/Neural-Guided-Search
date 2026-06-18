(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	spectrograph0 - mode
	GroundStation2 - direction
	GroundStation1 - direction
	Star0 - direction
	Planet3 - direction
	Phenomenon4 - direction
	Star5 - direction
	Star6 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
)
(:goal (and
	(pointing satellite0 Phenomenon4)
	(have_image Planet3 spectrograph0)
	(have_image Phenomenon4 spectrograph0)
	(have_image Star5 spectrograph0)
	(have_image Star6 spectrograph0)
))

)
