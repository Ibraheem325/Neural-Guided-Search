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
	Star2 - direction
	GroundStation3 - direction
	Star1 - direction
	Phenomenon4 - direction
	Phenomenon5 - direction
	Star6 - direction
	Planet7 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph3)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
)
(:goal (and
	(pointing satellite0 Phenomenon5)
	(have_image Phenomenon4 thermograph0)
	(have_image Phenomenon5 image2)
	(have_image Star6 spectrograph1)
	(have_image Planet7 thermograph0)
))

)
