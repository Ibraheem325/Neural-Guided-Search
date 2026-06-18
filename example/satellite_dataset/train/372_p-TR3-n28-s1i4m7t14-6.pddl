(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph6 - mode
	thermograph5 - mode
	image3 - mode
	infrared0 - mode
	thermograph2 - mode
	infrared4 - mode
	thermograph1 - mode
	Star0 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star4 - direction
	Star5 - direction
	Star8 - direction
	GroundStation10 - direction
	Star11 - direction
	Star12 - direction
	GroundStation13 - direction
	GroundStation6 - direction
	Star9 - direction
	GroundStation7 - direction
	Phenomenon14 - direction
	Star15 - direction
	Phenomenon16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 thermograph2)
	(supports instrument0 image3)
	(supports instrument0 infrared4)
	(supports instrument0 infrared0)
	(supports instrument0 thermograph5)
	(supports instrument0 spectrograph6)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 GroundStation6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation7)
)
(:goal (and
	(pointing satellite0 Phenomenon14)
	(have_image Phenomenon14 image3)
	(have_image Star15 infrared0)
	(have_image Star15 infrared4)
	(have_image Phenomenon16 thermograph1)
	(have_image Phenomenon16 infrared4)
	(have_image Planet17 image3)
))

)
