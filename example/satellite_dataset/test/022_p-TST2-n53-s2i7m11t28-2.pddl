(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	thermograph1 - mode
	thermograph10 - mode
	spectrograph9 - mode
	spectrograph6 - mode
	infrared3 - mode
	infrared2 - mode
	infrared7 - mode
	image4 - mode
	spectrograph0 - mode
	image5 - mode
	spectrograph8 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star10 - direction
	GroundStation14 - direction
	GroundStation21 - direction
	Star27 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation12 - direction
	Star17 - direction
	GroundStation9 - direction
	GroundStation24 - direction
	GroundStation20 - direction
	GroundStation11 - direction
	Star13 - direction
	GroundStation15 - direction
	GroundStation16 - direction
	Star25 - direction
	Star22 - direction
	GroundStation5 - direction
	Star23 - direction
	Star19 - direction
	GroundStation18 - direction
	Star4 - direction
	GroundStation26 - direction
	Planet28 - direction
	Star29 - direction
	Planet30 - direction
	Planet31 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph8)
	(supports instrument0 spectrograph0)
	(supports instrument0 thermograph10)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 Star19)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 Star17)
	(supports instrument1 image5)
	(supports instrument1 image4)
	(calibration_target instrument1 GroundStation15)
	(calibration_target instrument1 Star13)
	(calibration_target instrument1 GroundStation11)
	(calibration_target instrument1 GroundStation20)
	(calibration_target instrument1 GroundStation24)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 Star17)
	(supports instrument2 image5)
	(supports instrument2 infrared7)
	(calibration_target instrument2 GroundStation26)
	(calibration_target instrument2 GroundStation16)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star17)
	(supports instrument3 spectrograph9)
	(supports instrument3 infrared3)
	(supports instrument3 spectrograph6)
	(calibration_target instrument3 GroundStation26)
	(calibration_target instrument3 Star4)
	(calibration_target instrument3 GroundStation18)
	(calibration_target instrument3 Star19)
	(calibration_target instrument3 Star23)
	(calibration_target instrument3 GroundStation5)
	(calibration_target instrument3 Star22)
	(calibration_target instrument3 Star25)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star27)
)
(:goal (and
	(pointing satellite1 Star23)
	(have_image Planet28 spectrograph6)
	(have_image Star29 spectrograph8)
	(have_image Planet30 spectrograph8)
	(have_image Planet30 spectrograph9)
	(have_image Planet31 image5)
))

)
