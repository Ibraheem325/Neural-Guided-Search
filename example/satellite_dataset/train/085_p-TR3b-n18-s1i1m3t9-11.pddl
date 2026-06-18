(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	spectrograph1 - mode
	image2 - mode
	Star1 - direction
	GroundStation3 - direction
	Star4 - direction
	Star5 - direction
	GroundStation6 - direction
	Star7 - direction
	GroundStation8 - direction
	Star2 - direction
	GroundStation0 - direction
	Star9 - direction
	Star10 - direction
	Planet11 - direction
	Star12 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 thermograph0)
	(supports instrument0 image2)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
)
(:goal (and
	(pointing satellite0 Star1)
	(have_image Star9 thermograph0)
	(have_image Star10 spectrograph1)
	(have_image Planet11 thermograph0)
	(have_image Star12 spectrograph1)
))

)
