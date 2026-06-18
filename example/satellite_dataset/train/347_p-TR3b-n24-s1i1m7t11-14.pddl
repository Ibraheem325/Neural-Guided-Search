(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared4 - mode
	infrared2 - mode
	image1 - mode
	spectrograph5 - mode
	image3 - mode
	infrared6 - mode
	thermograph0 - mode
	GroundStation0 - direction
	Star1 - direction
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	Star8 - direction
	Star9 - direction
	Star10 - direction
	Planet11 - direction
	Phenomenon12 - direction
	Phenomenon13 - direction
	Star14 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 thermograph0)
	(supports instrument0 image3)
	(supports instrument0 infrared6)
	(supports instrument0 spectrograph5)
	(supports instrument0 image1)
	(supports instrument0 infrared4)
	(calibration_target instrument0 Star10)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon12)
)
(:goal (and
	(pointing satellite0 GroundStation7)
	(have_image Planet11 infrared2)
	(have_image Phenomenon12 infrared6)
	(have_image Phenomenon13 infrared4)
	(have_image Phenomenon13 infrared2)
	(have_image Star14 image3)
))

)
