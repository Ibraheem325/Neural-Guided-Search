(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	image2 - mode
	infrared1 - mode
	infrared5 - mode
	image3 - mode
	image4 - mode
	spectrograph0 - mode
	spectrograph6 - mode
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation4 - direction
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
	(supports instrument1 image3)
	(supports instrument1 infrared1)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 GroundStation12)
	(on_board instrument1 satellite1)
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
