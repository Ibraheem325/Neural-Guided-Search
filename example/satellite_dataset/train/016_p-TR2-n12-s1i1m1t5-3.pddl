(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	Star0 - direction
	Star1 - direction
	Star3 - direction
	GroundStation4 - direction
	Star2 - direction
	Star5 - direction
	Phenomenon6 - direction
	Phenomenon7 - direction
	Star8 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon7)
)
(:goal (and
	(have_image Star5 spectrograph0)
	(have_image Phenomenon6 spectrograph0)
	(have_image Phenomenon7 spectrograph0)
	(have_image Star8 spectrograph0)
))

)
