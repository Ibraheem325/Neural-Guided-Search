(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	image0 - mode
	thermograph3 - mode
	spectrograph1 - mode
	spectrograph2 - mode
	spectrograph4 - mode
	GroundStation0 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	Star8 - direction
	Star9 - direction
	GroundStation12 - direction
	GroundStation13 - direction
	Star14 - direction
	GroundStation15 - direction
	GroundStation16 - direction
	Star17 - direction
	GroundStation18 - direction
	Star19 - direction
	Star20 - direction
	Star21 - direction
	Star22 - direction
	Star23 - direction
	GroundStation26 - direction
	GroundStation27 - direction
	GroundStation28 - direction
	Star29 - direction
	GroundStation31 - direction
	GroundStation33 - direction
	GroundStation34 - direction
	Star35 - direction
	GroundStation38 - direction
	Star39 - direction
	GroundStation43 - direction
	GroundStation44 - direction
	Star45 - direction
	Star46 - direction
	GroundStation47 - direction
	Star48 - direction
	Star50 - direction
	GroundStation52 - direction
	GroundStation53 - direction
	GroundStation54 - direction
	GroundStation55 - direction
	Star25 - direction
	Star57 - direction
	Star4 - direction
	Star30 - direction
	GroundStation51 - direction
	GroundStation32 - direction
	Star42 - direction
	GroundStation37 - direction
	Star41 - direction
	GroundStation36 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	GroundStation1 - direction
	GroundStation56 - direction
	GroundStation49 - direction
	Star7 - direction
	GroundStation24 - direction
	GroundStation40 - direction
	Planet58 - direction
	Planet59 - direction
	Planet60 - direction
	Planet61 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph1)
	(supports instrument0 image0)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 Star57)
	(calibration_target instrument0 Star41)
	(calibration_target instrument0 Star25)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star22)
	(supports instrument1 thermograph3)
	(supports instrument1 image0)
	(supports instrument1 spectrograph4)
	(calibration_target instrument1 GroundStation37)
	(calibration_target instrument1 Star42)
	(calibration_target instrument1 GroundStation32)
	(calibration_target instrument1 GroundStation51)
	(calibration_target instrument1 Star30)
	(calibration_target instrument1 GroundStation24)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star29)
	(supports instrument2 spectrograph1)
	(calibration_target instrument2 GroundStation10)
	(calibration_target instrument2 GroundStation24)
	(calibration_target instrument2 Star7)
	(calibration_target instrument2 GroundStation36)
	(calibration_target instrument2 Star41)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star45)
	(supports instrument3 thermograph3)
	(calibration_target instrument3 GroundStation40)
	(calibration_target instrument3 GroundStation24)
	(calibration_target instrument3 Star7)
	(calibration_target instrument3 GroundStation49)
	(calibration_target instrument3 GroundStation56)
	(calibration_target instrument3 GroundStation1)
	(calibration_target instrument3 GroundStation11)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation34)
)
(:goal (and
	(pointing satellite2 GroundStation56)
	(have_image Planet58 spectrograph4)
	(have_image Planet59 spectrograph2)
	(have_image Planet60 spectrograph2)
	(have_image Planet61 thermograph3)
))

)
