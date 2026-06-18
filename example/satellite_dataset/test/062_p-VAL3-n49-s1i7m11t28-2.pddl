(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	thermograph1 - mode
	infrared2 - mode
	infrared3 - mode
	spectrograph8 - mode
	spectrograph0 - mode
	image5 - mode
	image4 - mode
	infrared7 - mode
	spectrograph6 - mode
	spectrograph9 - mode
	thermograph10 - mode
	Star0 - direction
	GroundStation1 - direction
	Star4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star10 - direction
	GroundStation14 - direction
	GroundStation18 - direction
	GroundStation21 - direction
	Star22 - direction
	Star23 - direction
	Star25 - direction
	Star27 - direction
	Star2 - direction
	GroundStation3 - direction
	Star19 - direction
	GroundStation12 - direction
	Star17 - direction
	GroundStation9 - direction
	GroundStation24 - direction
	GroundStation20 - direction
	GroundStation11 - direction
	Star13 - direction
	GroundStation15 - direction
	GroundStation16 - direction
	GroundStation26 - direction
	Planet28 - direction
	Star29 - direction
	Planet30 - direction
	Planet31 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 infrared3)
	(supports instrument0 thermograph10)
	(supports instrument0 spectrograph6)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 Star19)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 Star17)
	(supports instrument1 image5)
	(supports instrument1 spectrograph9)
	(supports instrument1 infrared7)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 GroundStation15)
	(calibration_target instrument1 Star13)
	(calibration_target instrument1 GroundStation11)
	(calibration_target instrument1 GroundStation20)
	(calibration_target instrument1 GroundStation24)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 Star17)
	(supports instrument2 image5)
	(supports instrument2 image4)
	(supports instrument2 spectrograph8)
	(calibration_target instrument2 GroundStation26)
	(calibration_target instrument2 GroundStation16)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star17)
)
(:goal (and
	(have_image Planet28 spectrograph6)
	(have_image Star29 spectrograph8)
	(have_image Planet30 spectrograph8)
	(have_image Planet30 spectrograph9)
	(have_image Planet31 image5)
))

)
