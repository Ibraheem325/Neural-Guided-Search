(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	thermograph5 - mode
	image3 - mode
	thermograph1 - mode
	thermograph2 - mode
	infrared0 - mode
	spectrograph6 - mode
	infrared4 - mode
	GroundStation1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star4 - direction
	Star8 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation13 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	Star12 - direction
	Star9 - direction
	Star5 - direction
	Star0 - direction
	Phenomenon14 - direction
	Star15 - direction
	Phenomenon16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 thermograph2)
	(supports instrument0 image3)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 GroundStation6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation7)
	(supports instrument1 thermograph2)
	(supports instrument1 infrared0)
	(supports instrument1 infrared4)
	(supports instrument1 spectrograph6)
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 Star12)
	(supports instrument2 thermograph5)
	(calibration_target instrument2 Star0)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon16)
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
