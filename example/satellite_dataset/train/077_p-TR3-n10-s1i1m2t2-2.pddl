(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph1 - mode
	spectrograph0 - mode
	Star1 - direction
	Star0 - direction
	Planet2 - direction
	Phenomenon3 - direction
	Planet4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet4)
)
(:goal (and
	(pointing satellite0 Planet4)
	(have_image Planet2 spectrograph0)
	(have_image Phenomenon3 thermograph1)
	(have_image Planet4 spectrograph0)
	(have_image Planet5 spectrograph0)
))

)
