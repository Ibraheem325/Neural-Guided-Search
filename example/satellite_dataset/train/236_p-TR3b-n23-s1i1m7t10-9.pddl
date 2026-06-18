(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph6 - mode
	image3 - mode
	spectrograph1 - mode
	infrared0 - mode
	image5 - mode
	thermograph4 - mode
	infrared2 - mode
	GroundStation0 - direction
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	GroundStation7 - direction
	Star9 - direction
	Star1 - direction
	Star8 - direction
	Planet10 - direction
	Phenomenon11 - direction
	Star12 - direction
	Star13 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph1)
	(supports instrument0 thermograph4)
	(supports instrument0 image5)
	(supports instrument0 infrared0)
	(supports instrument0 image3)
	(supports instrument0 spectrograph6)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 Star9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
)
(:goal (and
	(have_image Planet10 thermograph4)
	(have_image Phenomenon11 spectrograph6)
	(have_image Phenomenon11 infrared2)
	(have_image Star12 image5)
	(have_image Star13 thermograph4)
))

)
