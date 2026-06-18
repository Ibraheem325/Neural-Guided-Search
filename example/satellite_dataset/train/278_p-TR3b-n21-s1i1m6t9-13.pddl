(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph4 - mode
	image5 - mode
	image1 - mode
	spectrograph0 - mode
	infrared3 - mode
	thermograph2 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star7 - direction
	Star8 - direction
	GroundStation6 - direction
	Star9 - direction
	Phenomenon10 - direction
	Planet11 - direction
	Planet12 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph0)
	(supports instrument0 image5)
	(supports instrument0 spectrograph4)
	(calibration_target instrument0 GroundStation6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet12)
)
(:goal (and
	(have_image Star9 image5)
	(have_image Phenomenon10 thermograph2)
	(have_image Phenomenon10 spectrograph4)
	(have_image Planet11 infrared3)
	(have_image Planet11 image5)
	(have_image Planet12 image1)
	(have_image Planet12 image5)
))

)
