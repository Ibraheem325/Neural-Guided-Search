(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph2 - mode
	spectrograph3 - mode
	image0 - mode
	spectrograph1 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star4 - direction
	Star5 - direction
	GroundStation6 - direction
	Star7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation12 - direction
	GroundStation14 - direction
	GroundStation17 - direction
	GroundStation18 - direction
	GroundStation19 - direction
	Star20 - direction
	Star21 - direction
	Star22 - direction
	GroundStation16 - direction
	GroundStation15 - direction
	Star13 - direction
	Phenomenon23 - direction
	Planet24 - direction
	Planet25 - direction
	Phenomenon26 - direction
	Phenomenon27 - direction
	Planet28 - direction
	Planet29 - direction
	Planet30 - direction
	Phenomenon31 - direction
	Planet32 - direction
	Phenomenon33 - direction
	Planet34 - direction
	Planet35 - direction
	Phenomenon36 - direction
)
(:init
	(supports instrument0 spectrograph3)
	(supports instrument0 spectrograph1)
	(supports instrument0 image0)
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 Star13)
	(calibration_target instrument0 GroundStation15)
	(calibration_target instrument0 GroundStation16)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation17)
)
(:goal (and
	(have_image Phenomenon23 spectrograph1)
	(have_image Planet24 spectrograph3)
	(have_image Planet25 spectrograph1)
	(have_image Phenomenon26 spectrograph2)
	(have_image Phenomenon27 image0)
	(have_image Planet28 spectrograph3)
	(have_image Planet29 image0)
	(have_image Planet30 spectrograph2)
	(have_image Phenomenon31 spectrograph3)
	(have_image Planet32 spectrograph3)
	(have_image Phenomenon33 image0)
	(have_image Planet34 image0)
	(have_image Planet35 spectrograph1)
	(have_image Phenomenon36 spectrograph2)
))

)
