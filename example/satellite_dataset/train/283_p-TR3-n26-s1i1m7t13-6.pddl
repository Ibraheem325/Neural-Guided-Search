(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared0 - mode
	thermograph2 - mode
	infrared4 - mode
	image3 - mode
	thermograph1 - mode
	spectrograph6 - mode
	thermograph5 - mode
	Star0 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	Star8 - direction
	Star9 - direction
	GroundStation10 - direction
	Star11 - direction
	Star4 - direction
	Star5 - direction
	Star12 - direction
	Planet13 - direction
	Star14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 thermograph5)
	(supports instrument0 spectrograph6)
	(supports instrument0 image3)
	(supports instrument0 infrared4)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star12)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
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
