(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	spectrograph6 - mode
	thermograph1 - mode
	thermograph5 - mode
	infrared0 - mode
	infrared4 - mode
	image3 - mode
	thermograph2 - mode
	GroundStation1 - direction
	GroundStation3 - direction
	Star9 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation7 - direction
	Star4 - direction
	Star2 - direction
	Star12 - direction
	Star5 - direction
	GroundStation6 - direction
	Star0 - direction
	Star8 - direction
	Planet13 - direction
	Star14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star12)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 Star4)
	(supports instrument1 infrared0)
	(supports instrument1 thermograph1)
	(calibration_target instrument1 Star8)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 Star5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
	(supports instrument2 thermograph5)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 Star5)
	(calibration_target instrument2 Star2)
	(calibration_target instrument2 GroundStation6)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation10)
	(supports instrument3 infrared4)
	(calibration_target instrument3 Star2)
	(calibration_target instrument3 Star12)
	(calibration_target instrument3 Star8)
	(calibration_target instrument3 Star4)
	(supports instrument4 infrared0)
	(supports instrument4 thermograph2)
	(supports instrument4 thermograph1)
	(calibration_target instrument4 Star5)
	(calibration_target instrument4 Star12)
	(calibration_target instrument4 GroundStation6)
	(calibration_target instrument4 Star2)
	(supports instrument5 spectrograph6)
	(supports instrument5 image3)
	(supports instrument5 thermograph1)
	(calibration_target instrument5 Star8)
	(calibration_target instrument5 Star0)
	(calibration_target instrument5 GroundStation6)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet13)
)
(:goal (and
	(have_image Planet13 infrared0)
	(have_image Planet13 spectrograph6)
	(have_image Star14 image3)
	(have_image Phenomenon15 spectrograph6)
	(have_image Phenomenon15 infrared0)
	(have_image Phenomenon16 thermograph1)
))

)
