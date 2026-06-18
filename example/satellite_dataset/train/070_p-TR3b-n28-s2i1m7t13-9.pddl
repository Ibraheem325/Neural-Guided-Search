(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	infrared0 - mode
	spectrograph6 - mode
	thermograph4 - mode
	spectrograph1 - mode
	infrared2 - mode
	image5 - mode
	image3 - mode
	GroundStation0 - direction
	Star1 - direction
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	GroundStation7 - direction
	Star8 - direction
	GroundStation10 - direction
	Star12 - direction
	Star11 - direction
	Star9 - direction
	Star13 - direction
	Phenomenon14 - direction
	Planet15 - direction
	Planet16 - direction
)
(:init
	(supports instrument0 image5)
	(supports instrument0 thermograph4)
	(calibration_target instrument0 Star11)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star12)
	(supports instrument1 spectrograph6)
	(supports instrument1 spectrograph1)
	(supports instrument1 image3)
	(supports instrument1 infrared2)
	(supports instrument1 infrared0)
	(calibration_target instrument1 Star9)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet16)
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
