(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	Star0 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star4 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star12 - direction
	Star13 - direction
	Star15 - direction
	Star16 - direction
	GroundStation17 - direction
	Star18 - direction
	GroundStation19 - direction
	GroundStation20 - direction
	GroundStation21 - direction
	GroundStation22 - direction
	GroundStation23 - direction
	Star5 - direction
	Star14 - direction
	Star11 - direction
	Star24 - direction
	Planet25 - direction
	Planet26 - direction
	Planet27 - direction
	Star28 - direction
	Planet29 - direction
	Star30 - direction
	Phenomenon31 - direction
	Star32 - direction
	Star33 - direction
	Phenomenon34 - direction
	Planet35 - direction
	Planet36 - direction
	Phenomenon37 - direction
	Phenomenon38 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star11)
	(calibration_target instrument0 Star14)
	(calibration_target instrument0 Star5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star33)
)
(:goal (and
	(pointing satellite0 Star11)
	(have_image Star24 spectrograph0)
	(have_image Planet25 spectrograph0)
	(have_image Planet26 spectrograph0)
	(have_image Planet27 spectrograph0)
	(have_image Star28 spectrograph0)
	(have_image Planet29 spectrograph0)
	(have_image Star30 spectrograph0)
	(have_image Phenomenon31 spectrograph0)
	(have_image Star32 spectrograph0)
	(have_image Star33 spectrograph0)
	(have_image Phenomenon34 spectrograph0)
	(have_image Planet35 spectrograph0)
	(have_image Planet36 spectrograph0)
	(have_image Phenomenon37 spectrograph0)
	(have_image Phenomenon38 spectrograph0)
))

)
