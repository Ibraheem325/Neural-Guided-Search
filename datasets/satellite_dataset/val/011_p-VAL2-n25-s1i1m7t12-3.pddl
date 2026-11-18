(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	infrared1 - mode
	image2 - mode
	infrared5 - mode
	spectrograph6 - mode
	image4 - mode
	image3 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star10 - direction
	GroundStation11 - direction
	GroundStation9 - direction
	Planet12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 infrared5)
	(supports instrument0 infrared1)
	(supports instrument0 image3)
	(supports instrument0 image4)
	(supports instrument0 spectrograph6)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation11)
)
(:goal (and
	(have_image Planet12 spectrograph0)
	(have_image Phenomenon13 infrared5)
	(have_image Phenomenon13 image4)
	(have_image Phenomenon14 image4)
	(have_image Phenomenon15 infrared5)
	(have_image Phenomenon15 spectrograph0)
))

)
