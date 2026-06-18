(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	spectrograph0 - mode
	Star0 - direction
	GroundStation1 - direction
	Phenomenon2 - direction
	Star3 - direction
	Star4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 GroundStation1)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon2)
)
(:goal (and
	(pointing satellite0 Star0)
	(have_image Phenomenon2 spectrograph0)
	(have_image Star3 spectrograph0)
	(have_image Star4 spectrograph0)
	(have_image Planet5 spectrograph0)
))

)
