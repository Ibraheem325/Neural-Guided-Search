(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	infrared2 - mode
	spectrograph1 - mode
	image0 - mode
	GroundStation1 - direction
	Star2 - direction
	Star3 - direction
	GroundStation0 - direction
	GroundStation5 - direction
	Star6 - direction
	GroundStation4 - direction
	Planet7 - direction
	Phenomenon8 - direction
	Phenomenon9 - direction
	Phenomenon10 - direction
	Star11 - direction
	Phenomenon12 - direction
	Star13 - direction
	Phenomenon14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 spectrograph1)
	(supports instrument1 infrared2)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation4)
	(calibration_target instrument1 Star6)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
)
(:goal (and
	(have_image Planet7 spectrograph1)
	(have_image Phenomenon8 infrared2)
	(have_image Phenomenon9 spectrograph1)
	(have_image Phenomenon10 spectrograph1)
	(have_image Star11 infrared2)
	(have_image Phenomenon12 image0)
	(have_image Star13 infrared2)
	(have_image Phenomenon14 infrared2)
	(have_image Planet15 infrared2)
))

)
