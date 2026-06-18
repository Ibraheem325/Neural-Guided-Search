(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared3 - mode
	image1 - mode
	image5 - mode
	spectrograph0 - mode
	thermograph2 - mode
	spectrograph4 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star8 - direction
	Star9 - direction
	Star10 - direction
	Star7 - direction
	GroundStation6 - direction
	Star11 - direction
	Star12 - direction
	Star13 - direction
	Planet14 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 thermograph2)
	(supports instrument0 image5)
	(supports instrument0 spectrograph4)
	(supports instrument0 image1)
	(supports instrument0 infrared3)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 Star7)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star9)
)
(:goal (and
	(pointing satellite0 Star8)
	(have_image Star11 infrared3)
	(have_image Star12 spectrograph4)
	(have_image Star13 image1)
	(have_image Star13 infrared3)
	(have_image Planet14 image1)
))

)
