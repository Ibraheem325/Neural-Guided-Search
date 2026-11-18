(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	image0 - mode
	spectrograph1 - mode
	GroundStation0 - direction
	Star2 - direction
	Star3 - direction
	GroundStation5 - direction
	Star6 - direction
	Star8 - direction
	GroundStation9 - direction
	Star10 - direction
	GroundStation11 - direction
	Star12 - direction
	GroundStation15 - direction
	Star4 - direction
	GroundStation14 - direction
	Star7 - direction
	Star1 - direction
	Star13 - direction
	Star16 - direction
	Phenomenon17 - direction
	Planet18 - direction
	Phenomenon19 - direction
	Planet20 - direction
	Star21 - direction
	Star22 - direction
	Phenomenon23 - direction
	Star24 - direction
	Phenomenon25 - direction
	Phenomenon26 - direction
	Star27 - direction
	Star28 - direction
	Phenomenon29 - direction
	Planet30 - direction
	Planet31 - direction
	Planet32 - direction
	Star33 - direction
	Planet34 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 GroundStation14)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet20)
	(supports instrument1 spectrograph1)
	(supports instrument1 image0)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 Star7)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet31)
	(supports instrument2 image0)
	(supports instrument2 spectrograph1)
	(calibration_target instrument2 Star13)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon29)
)
(:goal (and
	(pointing satellite1 Phenomenon25)
	(pointing satellite2 Star7)
	(have_image Star16 spectrograph1)
	(have_image Phenomenon17 image0)
	(have_image Planet18 spectrograph1)
	(have_image Phenomenon19 image0)
	(have_image Planet20 image0)
	(have_image Star21 image0)
	(have_image Star22 image0)
	(have_image Phenomenon23 spectrograph1)
	(have_image Star24 spectrograph1)
	(have_image Phenomenon25 image0)
	(have_image Phenomenon26 spectrograph1)
	(have_image Star27 image0)
	(have_image Star28 spectrograph1)
	(have_image Phenomenon29 spectrograph1)
	(have_image Planet30 image0)
	(have_image Planet31 image0)
	(have_image Planet32 spectrograph1)
	(have_image Star33 spectrograph1)
	(have_image Planet34 image0)
))

)
