(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph2 - mode
	thermograph6 - mode
	infrared4 - mode
	thermograph1 - mode
	infrared3 - mode
	spectrograph5 - mode
	image0 - mode
	GroundStation1 - direction
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	GroundStation5 - direction
	Star0 - direction
	Star7 - direction
	Phenomenon12 - direction
	Star13 - direction
	Planet14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 spectrograph5)
	(supports instrument0 image0)
	(supports instrument0 infrared3)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared4)
	(supports instrument0 thermograph6)
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 GroundStation5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation10)
)
(:goal (and
	(have_image Phenomenon12 infrared4)
	(have_image Star13 infrared3)
	(have_image Star13 thermograph1)
	(have_image Planet14 image0)
	(have_image Phenomenon15 spectrograph2)
	(have_image Phenomenon15 thermograph6)
))

)
