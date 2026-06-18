(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	spectrograph3 - mode
	spectrograph1 - mode
	image2 - mode
	GroundStation0 - direction
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star4 - direction
	Planet5 - direction
	Phenomenon6 - direction
	Planet7 - direction
	Star8 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 image2)
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph3)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
)
(:goal (and
	(have_image Planet5 spectrograph1)
	(have_image Phenomenon6 spectrograph3)
	(have_image Planet7 spectrograph3)
	(have_image Star8 thermograph0)
))

)
