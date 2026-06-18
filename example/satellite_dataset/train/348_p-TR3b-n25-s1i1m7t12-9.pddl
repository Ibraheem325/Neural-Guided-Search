(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared0 - mode
	image5 - mode
	thermograph4 - mode
	infrared2 - mode
	image3 - mode
	spectrograph1 - mode
	spectrograph6 - mode
	GroundStation0 - direction
	Star1 - direction
	Star3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	Star8 - direction
	Star9 - direction
	Star11 - direction
	Star2 - direction
	GroundStation7 - direction
	GroundStation10 - direction
	Phenomenon12 - direction
	Star13 - direction
	Planet14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 image3)
	(supports instrument0 spectrograph6)
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared2)
	(supports instrument0 thermograph4)
	(supports instrument0 image5)
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
)
(:goal (and
	(have_image Phenomenon12 image3)
	(have_image Star13 image5)
	(have_image Star13 infrared0)
	(have_image Planet14 image5)
	(have_image Planet14 infrared2)
	(have_image Planet15 thermograph4)
	(have_image Planet15 image5)
))

)
