(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	infrared0 - mode
	image3 - mode
	thermograph2 - mode
	image1 - mode
	Star0 - direction
	Star2 - direction
	Star3 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation11 - direction
	Star12 - direction
	GroundStation13 - direction
	Star14 - direction
	GroundStation15 - direction
	GroundStation16 - direction
	GroundStation18 - direction
	GroundStation20 - direction
	GroundStation21 - direction
	GroundStation23 - direction
	GroundStation26 - direction
	GroundStation27 - direction
	GroundStation28 - direction
	GroundStation29 - direction
	Star31 - direction
	Star32 - direction
	GroundStation33 - direction
	GroundStation34 - direction
	GroundStation35 - direction
	Star36 - direction
	Star37 - direction
	GroundStation41 - direction
	Star42 - direction
	GroundStation43 - direction
	Star45 - direction
	GroundStation47 - direction
	Star48 - direction
	Star49 - direction
	GroundStation50 - direction
	Star51 - direction
	GroundStation52 - direction
	GroundStation53 - direction
	GroundStation55 - direction
	Star56 - direction
	GroundStation57 - direction
	GroundStation38 - direction
	Star24 - direction
	GroundStation40 - direction
	Star1 - direction
	Star39 - direction
	Star19 - direction
	GroundStation4 - direction
	GroundStation46 - direction
	Star54 - direction
	GroundStation44 - direction
	GroundStation22 - direction
	GroundStation17 - direction
	GroundStation25 - direction
	Star30 - direction
	Star10 - direction
	Star58 - direction
	Phenomenon59 - direction
	Star60 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star24)
	(calibration_target instrument0 GroundStation38)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star36)
	(supports instrument1 thermograph2)
	(supports instrument1 infrared0)
	(supports instrument1 image1)
	(calibration_target instrument1 Star19)
	(calibration_target instrument1 Star39)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 GroundStation17)
	(calibration_target instrument1 GroundStation40)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star1)
	(supports instrument2 image1)
	(supports instrument2 image3)
	(calibration_target instrument2 Star10)
	(calibration_target instrument2 Star30)
	(calibration_target instrument2 GroundStation25)
	(calibration_target instrument2 GroundStation17)
	(calibration_target instrument2 GroundStation22)
	(calibration_target instrument2 GroundStation44)
	(calibration_target instrument2 Star54)
	(calibration_target instrument2 GroundStation46)
	(calibration_target instrument2 GroundStation4)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation17)
)
(:goal (and
	(have_image Star58 image1)
	(have_image Phenomenon59 thermograph2)
	(have_image Star60 thermograph2)
))

)
