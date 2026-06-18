(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	spectrograph6 - mode
	thermograph4 - mode
	infrared0 - mode
	infrared2 - mode
	image3 - mode
	image5 - mode
	GroundStation0 - direction
	Star1 - direction
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	GroundStation7 - direction
	Star8 - direction
	Star9 - direction
	GroundStation10 - direction
	Star12 - direction
	Star11 - direction
	Star13 - direction
	Phenomenon14 - direction
	Planet15 - direction
	Planet16 - direction
)
(:init
	(supports instrument0 image5)
	(supports instrument0 image3)
	(supports instrument0 infrared2)
	(supports instrument0 infrared0)
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph6)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star11)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star12)
)
(:goal (and
	(have_image Star13 image3)
	(have_image Phenomenon14 thermograph4)
	(have_image Planet15 infrared2)
	(have_image Planet15 image3)
	(have_image Planet16 image3)
	(have_image Planet16 thermograph4)
))

)
