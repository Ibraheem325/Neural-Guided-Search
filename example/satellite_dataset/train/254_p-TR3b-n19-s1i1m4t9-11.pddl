(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	image2 - mode
	spectrograph1 - mode
	spectrograph3 - mode
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star4 - direction
	GroundStation6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation0 - direction
	GroundStation5 - direction
	Phenomenon9 - direction
	Star10 - direction
	Star11 - direction
	Phenomenon12 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph3)
	(supports instrument0 image2)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 Star8)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon9)
)
(:goal (and
	(have_image Phenomenon9 spectrograph3)
	(have_image Star10 thermograph0)
	(have_image Star11 spectrograph3)
	(have_image Phenomenon12 image2)
))

)
