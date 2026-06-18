(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	image2 - mode
	thermograph0 - mode
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation8 - direction
	Star9 - direction
	Star4 - direction
	GroundStation0 - direction
	Star7 - direction
	Phenomenon10 - direction
	Phenomenon11 - direction
	Phenomenon12 - direction
	Star13 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 spectrograph1)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon12)
)
(:goal (and
	(have_image Phenomenon10 thermograph0)
	(have_image Phenomenon11 thermograph0)
	(have_image Phenomenon12 image2)
	(have_image Star13 image2)
))

)
