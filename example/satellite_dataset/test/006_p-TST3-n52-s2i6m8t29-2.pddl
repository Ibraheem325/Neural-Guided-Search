(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	infrared3 - mode
	image4 - mode
	infrared2 - mode
	image5 - mode
	infrared7 - mode
	thermograph1 - mode
	spectrograph6 - mode
	spectrograph0 - mode
	GroundStation0 - direction
	Star3 - direction
	GroundStation4 - direction
	Star8 - direction
	Star9 - direction
	GroundStation10 - direction
	Star12 - direction
	Star16 - direction
	Star17 - direction
	Star21 - direction
	GroundStation22 - direction
	GroundStation23 - direction
	GroundStation25 - direction
	GroundStation11 - direction
	GroundStation19 - direction
	Star20 - direction
	Star18 - direction
	GroundStation6 - direction
	Star7 - direction
	GroundStation14 - direction
	GroundStation24 - direction
	Star2 - direction
	Star27 - direction
	Star13 - direction
	Star26 - direction
	GroundStation5 - direction
	Star28 - direction
	Star1 - direction
	Star15 - direction
	Planet29 - direction
	Star30 - direction
	Phenomenon31 - direction
	Star32 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph0)
	(supports instrument0 image5)
	(calibration_target instrument0 GroundStation11)
	(calibration_target instrument0 GroundStation24)
	(calibration_target instrument0 Star28)
	(calibration_target instrument0 GroundStation25)
	(supports instrument1 infrared7)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 Star7)
	(calibration_target instrument1 GroundStation6)
	(calibration_target instrument1 Star18)
	(calibration_target instrument1 Star26)
	(calibration_target instrument1 Star20)
	(calibration_target instrument1 Star28)
	(calibration_target instrument1 GroundStation19)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star17)
	(supports instrument2 infrared7)
	(supports instrument2 spectrograph6)
	(supports instrument2 thermograph1)
	(supports instrument2 infrared3)
	(calibration_target instrument2 GroundStation5)
	(calibration_target instrument2 GroundStation14)
	(supports instrument3 image4)
	(calibration_target instrument3 Star15)
	(calibration_target instrument3 Star1)
	(calibration_target instrument3 Star28)
	(calibration_target instrument3 GroundStation5)
	(calibration_target instrument3 Star26)
	(calibration_target instrument3 Star13)
	(calibration_target instrument3 Star27)
	(calibration_target instrument3 Star2)
	(calibration_target instrument3 GroundStation24)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star26)
)
(:goal (and
	(pointing satellite1 GroundStation10)
	(have_image Planet29 thermograph1)
	(have_image Star30 image4)
	(have_image Star30 infrared2)
	(have_image Phenomenon31 infrared7)
	(have_image Phenomenon31 image5)
	(have_image Star32 spectrograph6)
	(have_image Star32 infrared7)
))

)
