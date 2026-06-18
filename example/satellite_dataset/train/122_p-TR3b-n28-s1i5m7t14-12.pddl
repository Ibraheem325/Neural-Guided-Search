(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	image6 - mode
	infrared5 - mode
	spectrograph4 - mode
	image1 - mode
	thermograph0 - mode
	thermograph3 - mode
	infrared2 - mode
	Star1 - direction
	Star2 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation6 - direction
	Star8 - direction
	Star11 - direction
	GroundStation13 - direction
	Star10 - direction
	GroundStation0 - direction
	Star3 - direction
	Star9 - direction
	Star7 - direction
	Star12 - direction
	Phenomenon14 - direction
	Star15 - direction
	Phenomenon16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 thermograph3)
	(supports instrument0 infrared2)
	(supports instrument0 image1)
	(supports instrument0 infrared5)
	(calibration_target instrument0 GroundStation13)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 image6)
	(calibration_target instrument1 Star12)
	(calibration_target instrument1 Star3)
	(calibration_target instrument1 Star7)
	(supports instrument2 image6)
	(supports instrument2 spectrograph4)
	(calibration_target instrument2 GroundStation0)
	(calibration_target instrument2 Star10)
	(calibration_target instrument2 Star12)
	(supports instrument3 infrared2)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 Star12)
	(calibration_target instrument3 Star7)
	(calibration_target instrument3 Star9)
	(calibration_target instrument3 Star3)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
)
(:goal (and
	(pointing satellite0 Star7)
	(have_image Phenomenon14 thermograph3)
	(have_image Star15 spectrograph4)
	(have_image Star15 image1)
	(have_image Phenomenon16 image6)
	(have_image Phenomenon17 spectrograph4)
	(have_image Phenomenon17 image1)
))

)
