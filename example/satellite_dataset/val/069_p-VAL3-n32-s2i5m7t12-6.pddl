(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	spectrograph6 - mode
	thermograph1 - mode
	image3 - mode
	infrared0 - mode
	thermograph2 - mode
	infrared4 - mode
	thermograph5 - mode
	GroundStation1 - direction
	GroundStation3 - direction
	Star4 - direction
	Star5 - direction
	GroundStation6 - direction
	Star0 - direction
	Star8 - direction
	Star11 - direction
	GroundStation7 - direction
	GroundStation10 - direction
	Star2 - direction
	Star9 - direction
	Star12 - direction
	Star13 - direction
	Planet14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 infrared4)
	(supports instrument0 thermograph1)
	(supports instrument0 image3)
	(calibration_target instrument0 GroundStation10)
	(supports instrument1 spectrograph6)
	(supports instrument1 thermograph1)
	(supports instrument1 infrared0)
	(calibration_target instrument1 GroundStation6)
	(calibration_target instrument1 Star2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
	(supports instrument2 thermograph5)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 Star11)
	(calibration_target instrument2 Star0)
	(calibration_target instrument2 Star9)
	(supports instrument3 thermograph5)
	(calibration_target instrument3 Star11)
	(calibration_target instrument3 GroundStation7)
	(calibration_target instrument3 Star8)
	(supports instrument4 spectrograph6)
	(supports instrument4 thermograph5)
	(calibration_target instrument4 Star2)
	(calibration_target instrument4 GroundStation10)
	(calibration_target instrument4 GroundStation7)
	(supports instrument5 thermograph1)
	(calibration_target instrument5 Star9)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star4)
)
(:goal (and
	(have_image Star12 infrared4)
	(have_image Star13 infrared0)
	(have_image Star13 thermograph2)
	(have_image Planet14 infrared4)
	(have_image Planet14 thermograph5)
	(have_image Planet15 image3)
))

)
