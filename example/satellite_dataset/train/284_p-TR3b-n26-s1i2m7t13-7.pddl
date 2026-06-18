(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	spectrograph2 - mode
	image0 - mode
	infrared3 - mode
	spectrograph5 - mode
	thermograph6 - mode
	thermograph1 - mode
	infrared4 - mode
	Star0 - direction
	GroundStation1 - direction
	Star3 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	GroundStation4 - direction
	Star2 - direction
	Phenomenon13 - direction
	Planet14 - direction
	Planet15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 spectrograph5)
	(supports instrument0 spectrograph2)
	(supports instrument0 infrared4)
	(supports instrument0 infrared3)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 Star2)
	(supports instrument1 spectrograph5)
	(supports instrument1 thermograph6)
	(supports instrument1 image0)
	(calibration_target instrument1 Star2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet15)
)
(:goal (and
	(have_image Phenomenon13 spectrograph2)
	(have_image Phenomenon13 thermograph6)
	(have_image Planet14 image0)
	(have_image Planet14 infrared4)
	(have_image Planet15 infrared3)
	(have_image Planet15 thermograph6)
	(have_image Phenomenon16 spectrograph5)
	(have_image Phenomenon16 thermograph1)
))

)
