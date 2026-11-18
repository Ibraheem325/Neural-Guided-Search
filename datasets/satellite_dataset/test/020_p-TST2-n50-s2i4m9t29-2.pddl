(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	thermograph1 - mode
	spectrograph0 - mode
	infrared7 - mode
	image4 - mode
	infrared3 - mode
	spectrograph8 - mode
	spectrograph6 - mode
	image5 - mode
	infrared2 - mode
	GroundStation0 - direction
	GroundStation2 - direction
	Star5 - direction
	GroundStation8 - direction
	GroundStation11 - direction
	GroundStation13 - direction
	GroundStation14 - direction
	GroundStation18 - direction
	GroundStation19 - direction
	Star20 - direction
	GroundStation23 - direction
	GroundStation24 - direction
	GroundStation26 - direction
	Star17 - direction
	GroundStation6 - direction
	Star7 - direction
	Star12 - direction
	GroundStation28 - direction
	Star10 - direction
	GroundStation21 - direction
	GroundStation9 - direction
	GroundStation16 - direction
	GroundStation27 - direction
	GroundStation4 - direction
	Star25 - direction
	GroundStation15 - direction
	Star3 - direction
	Star22 - direction
	Star1 - direction
	Star29 - direction
	Phenomenon30 - direction
	Phenomenon31 - direction
	Planet32 - direction
)
(:init
	(supports instrument0 image5)
	(supports instrument0 infrared7)
	(supports instrument0 spectrograph8)
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation28)
	(calibration_target instrument0 Star12)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 GroundStation16)
	(calibration_target instrument0 Star22)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 Star17)
	(supports instrument1 infrared3)
	(supports instrument1 spectrograph6)
	(calibration_target instrument1 GroundStation16)
	(calibration_target instrument1 Star22)
	(calibration_target instrument1 GroundStation21)
	(calibration_target instrument1 Star10)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation9)
	(supports instrument2 infrared3)
	(supports instrument2 image4)
	(supports instrument2 thermograph1)
	(calibration_target instrument2 Star1)
	(calibration_target instrument2 Star22)
	(calibration_target instrument2 Star3)
	(calibration_target instrument2 GroundStation15)
	(calibration_target instrument2 Star25)
	(calibration_target instrument2 GroundStation4)
	(calibration_target instrument2 GroundStation27)
	(calibration_target instrument2 GroundStation16)
	(calibration_target instrument2 GroundStation9)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star29)
)
(:goal (and
	(pointing satellite0 Star12)
	(pointing satellite1 GroundStation18)
	(have_image Star29 infrared3)
	(have_image Phenomenon30 spectrograph8)
	(have_image Phenomenon31 infrared2)
	(have_image Phenomenon31 infrared3)
	(have_image Planet32 image5)
	(have_image Planet32 infrared7)
	(have_image Planet32 spectrograph6)
))

)
