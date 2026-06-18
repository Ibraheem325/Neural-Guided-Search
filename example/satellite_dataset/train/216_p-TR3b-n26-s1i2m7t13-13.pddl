(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	infrared6 - mode
	spectrograph0 - mode
	image5 - mode
	image1 - mode
	infrared3 - mode
	thermograph2 - mode
	spectrograph4 - mode
	Star1 - direction
	Star3 - direction
	Star4 - direction
	Star5 - direction
	GroundStation8 - direction
	Star9 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation2 - direction
	GroundStation7 - direction
	Star12 - direction
	GroundStation0 - direction
	GroundStation6 - direction
	Star13 - direction
	Phenomenon14 - direction
	Planet15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 thermograph2)
	(supports instrument0 image1)
	(supports instrument0 image5)
	(supports instrument0 infrared6)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 Star12)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 GroundStation2)
	(supports instrument1 spectrograph0)
	(supports instrument1 spectrograph4)
	(calibration_target instrument1 GroundStation6)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
)
(:goal (and
	(have_image Star13 spectrograph0)
	(have_image Star13 image5)
	(have_image Phenomenon14 infrared3)
	(have_image Phenomenon14 spectrograph4)
	(have_image Planet15 spectrograph4)
	(have_image Planet15 infrared3)
	(have_image Phenomenon16 spectrograph4)
))

)
