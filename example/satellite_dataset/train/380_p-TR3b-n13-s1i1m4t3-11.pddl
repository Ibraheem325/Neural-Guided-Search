(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image2 - mode
	thermograph0 - mode
	spectrograph1 - mode
	spectrograph3 - mode
	Star1 - direction
	Star2 - direction
	GroundStation0 - direction
	Planet3 - direction
	Planet4 - direction
	Planet5 - direction
	Planet6 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph3)
	(supports instrument0 thermograph0)
	(supports instrument0 image2)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet6)
)
(:goal (and
	(have_image Planet3 spectrograph3)
	(have_image Planet4 spectrograph3)
	(have_image Planet5 spectrograph1)
	(have_image Planet6 spectrograph1)
))

)
