(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	thermograph1 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	Star10 - direction
	GroundStation6 - direction
	Star7 - direction
	Star11 - direction
	Phenomenon12 - direction
	Star13 - direction
	Planet14 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet14)
)
(:goal (and
	(pointing satellite0 Star7)
	(have_image Star11 thermograph1)
	(have_image Phenomenon12 spectrograph0)
	(have_image Star13 thermograph1)
	(have_image Planet14 thermograph1)
))

)
