(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image3 - mode
	thermograph4 - mode
	infrared2 - mode
	image5 - mode
	spectrograph6 - mode
	infrared0 - mode
	spectrograph1 - mode
	GroundStation0 - direction
	Star1 - direction
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	Star8 - direction
	GroundStation10 - direction
	Star9 - direction
	GroundStation7 - direction
	Star11 - direction
	Phenomenon12 - direction
	Phenomenon13 - direction
	Star14 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph6)
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared0)
	(supports instrument0 image5)
	(supports instrument0 thermograph4)
	(supports instrument0 image3)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 Star9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon12)
)
(:goal (and
	(have_image Star11 infrared2)
	(have_image Star11 image3)
	(have_image Phenomenon12 image5)
	(have_image Phenomenon12 image3)
	(have_image Phenomenon13 spectrograph1)
	(have_image Phenomenon13 spectrograph6)
	(have_image Star14 thermograph4)
	(have_image Star14 infrared2)
))

)
