(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image1 - mode
	thermograph2 - mode
	spectrograph4 - mode
	infrared3 - mode
	spectrograph0 - mode
	image5 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	GroundStation2 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
)
(:init
	(supports instrument0 spectrograph4)
	(supports instrument0 thermograph2)
	(supports instrument0 image5)
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared3)
	(supports instrument0 image1)
	(calibration_target instrument0 GroundStation2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
)
(:goal (and
	(have_image Star5 image1)
	(have_image Star6 image5)
	(have_image Star6 infrared3)
	(have_image Star7 spectrograph0)
	(have_image Star7 spectrograph4)
	(have_image Star8 image5)
))

)
