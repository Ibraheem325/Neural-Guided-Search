(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	spectrograph6 - mode
	thermograph5 - mode
	thermograph1 - mode
	infrared0 - mode
	thermograph2 - mode
	infrared4 - mode
	image3 - mode
	GroundStation10 - direction
	Star11 - direction
	GroundStation13 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	Star12 - direction
	Star9 - direction
	Star5 - direction
	Star0 - direction
	GroundStation1 - direction
	Star2 - direction
	Star8 - direction
	Star4 - direction
	GroundStation3 - direction
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
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 Star12)
	(supports instrument2 thermograph5)
	(supports instrument2 infrared4)
	(calibration_target instrument2 Star0)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon16)
	(supports instrument3 spectrograph6)
	(supports instrument3 infrared0)
	(supports instrument3 image3)
	(calibration_target instrument3 Star4)
	(calibration_target instrument3 Star8)
	(calibration_target instrument3 Star2)
	(calibration_target instrument3 GroundStation1)
	(supports instrument4 thermograph2)
	(supports instrument4 spectrograph6)
	(calibration_target instrument4 GroundStation3)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation1)
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
