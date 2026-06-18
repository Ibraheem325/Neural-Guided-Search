(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	infrared5 - mode
	image3 - mode
	infrared1 - mode
	spectrograph0 - mode
	spectrograph6 - mode
	image4 - mode
	image2 - mode
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation8 - direction
	Star10 - direction
	GroundStation11 - direction
	Star13 - direction
	GroundStation7 - direction
	GroundStation0 - direction
	GroundStation12 - direction
	GroundStation9 - direction
	GroundStation4 - direction
	Phenomenon14 - direction
	Star15 - direction
	Phenomenon16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 infrared5)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 GroundStation9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon14)
	(supports instrument1 spectrograph6)
	(supports instrument1 spectrograph0)
	(supports instrument1 image4)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 GroundStation12)
	(supports instrument2 spectrograph6)
	(supports instrument2 spectrograph0)
	(supports instrument2 image2)
	(supports instrument2 infrared1)
	(supports instrument2 image3)
	(calibration_target instrument2 GroundStation4)
	(calibration_target instrument2 GroundStation9)
	(calibration_target instrument2 GroundStation12)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation0)
)
(:goal (and
	(have_image Phenomenon14 image4)
	(have_image Star15 infrared5)
	(have_image Star15 image2)
	(have_image Phenomenon16 image3)
	(have_image Planet17 spectrograph0)
))

)
