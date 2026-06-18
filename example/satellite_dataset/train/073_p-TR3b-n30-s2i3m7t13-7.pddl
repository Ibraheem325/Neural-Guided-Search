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
	infrared3 - mode
	spectrograph2 - mode
	image0 - mode
	spectrograph5 - mode
	thermograph1 - mode
	thermograph6 - mode
	infrared4 - mode
	Star0 - direction
	Star3 - direction
	GroundStation5 - direction
	Star8 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	GroundStation4 - direction
	Star2 - direction
	GroundStation6 - direction
	Star7 - direction
	GroundStation1 - direction
	GroundStation9 - direction
	Phenomenon13 - direction
	Planet14 - direction
	Planet15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 spectrograph5)
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 Star2)
	(supports instrument1 spectrograph5)
	(calibration_target instrument1 Star2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet15)
	(supports instrument2 image0)
	(supports instrument2 thermograph1)
	(supports instrument2 spectrograph2)
	(calibration_target instrument2 GroundStation6)
	(supports instrument3 thermograph6)
	(supports instrument3 spectrograph2)
	(supports instrument3 image0)
	(calibration_target instrument3 Star7)
	(calibration_target instrument3 GroundStation1)
	(supports instrument4 image0)
	(supports instrument4 infrared3)
	(supports instrument4 infrared4)
	(calibration_target instrument4 GroundStation9)
	(calibration_target instrument4 GroundStation1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation11)
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
