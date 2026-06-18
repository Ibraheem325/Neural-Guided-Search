(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	thermograph2 - mode
	infrared6 - mode
	spectrograph4 - mode
	image1 - mode
	infrared3 - mode
	image5 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	Star4 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation8 - direction
	Star9 - direction
	GroundStation10 - direction
	GroundStation7 - direction
	Star11 - direction
	Star12 - direction
	Star13 - direction
	Phenomenon14 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 image1)
	(supports instrument0 image5)
	(supports instrument0 spectrograph4)
	(supports instrument0 infrared6)
	(supports instrument0 thermograph2)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation7)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation7)
)
(:goal (and
	(pointing satellite0 Star1)
	(have_image Star11 thermograph2)
	(have_image Star11 image1)
	(have_image Star12 infrared6)
	(have_image Star13 image5)
	(have_image Phenomenon14 infrared3)
	(have_image Phenomenon14 image5)
))

)
