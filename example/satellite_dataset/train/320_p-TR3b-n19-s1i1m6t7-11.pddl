(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	image5 - mode
	thermograph4 - mode
	image2 - mode
	spectrograph3 - mode
	thermograph0 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	Star4 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation3 - direction
	Phenomenon7 - direction
	Phenomenon8 - direction
	Star9 - direction
	Star10 - direction
)
(:init
	(supports instrument0 spectrograph3)
	(supports instrument0 image2)
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph4)
	(supports instrument0 image5)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 GroundStation3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon7)
)
(:goal (and
	(pointing satellite0 Star10)
	(have_image Phenomenon7 thermograph4)
	(have_image Phenomenon7 image5)
	(have_image Phenomenon8 thermograph0)
	(have_image Star9 spectrograph3)
	(have_image Star9 spectrograph1)
	(have_image Star10 image2)
	(have_image Star10 spectrograph1)
))

)
