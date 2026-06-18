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
	GroundStation5 - direction
	GroundStation6 - direction
	Star7 - direction
	Star9 - direction
	Star10 - direction
	Star11 - direction
	GroundStation12 - direction
	GroundStation13 - direction
	Star8 - direction
	Star4 - direction
	Star14 - direction
	Planet15 - direction
	Star16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 spectrograph3)
	(supports instrument0 spectrograph1)
	(supports instrument0 image2)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 Star8)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star7)
)
(:goal (and
	(pointing satellite0 Star7)
	(have_image Star14 image2)
	(have_image Planet15 thermograph0)
	(have_image Star16 spectrograph1)
	(have_image Star17 image2)
))

)
