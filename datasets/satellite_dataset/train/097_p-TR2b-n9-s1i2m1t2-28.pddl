(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	Star1 - direction
	Star0 - direction
	Phenomenon2 - direction
	Phenomenon3 - direction
	Phenomenon4 - direction
	Phenomenon5 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon2)
)
(:goal (and
	(pointing satellite0 Star1)
	(have_image Phenomenon2 spectrograph0)
	(have_image Phenomenon3 spectrograph0)
	(have_image Phenomenon4 spectrograph0)
	(have_image Phenomenon5 spectrograph0)
))

)
