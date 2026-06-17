(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	infrared3 - mode
	thermograph1 - mode
	spectrograph6 - mode
	infrared2 - mode
	image5 - mode
	image4 - mode
	Star0 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation6 - direction
	Star7 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation8 - direction
	GroundStation3 - direction
	GroundStation12 - direction
	Planet13 - direction
	Phenomenon14 - direction
	Planet15 - direction
	Planet16 - direction
)
(:init
	(supports instrument0 image5)
	(supports instrument0 image4)
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph6)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 GroundStation8)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation6)
)
(:goal (and
	(pointing satellite0 GroundStation10)
	(have_image Planet13 spectrograph6)
	(have_image Phenomenon14 thermograph1)
	(have_image Phenomenon14 spectrograph6)
	(have_image Planet15 infrared2)
	(have_image Planet16 thermograph1)
	(have_image Planet16 image4)
))

)
