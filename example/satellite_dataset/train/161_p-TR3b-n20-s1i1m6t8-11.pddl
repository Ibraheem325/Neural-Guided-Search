(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image2 - mode
	image5 - mode
	spectrograph3 - mode
	thermograph4 - mode
	thermograph0 - mode
	spectrograph1 - mode
	Star0 - direction
	Star2 - direction
	GroundStation3 - direction
	Star4 - direction
	Star5 - direction
	GroundStation6 - direction
	Star7 - direction
	Star1 - direction
	Star8 - direction
	Planet9 - direction
	Phenomenon10 - direction
	Phenomenon11 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph1)
	(supports instrument0 thermograph0)
	(supports instrument0 spectrograph3)
	(supports instrument0 image5)
	(supports instrument0 image2)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
)
(:goal (and
	(have_image Star8 image2)
	(have_image Planet9 image5)
	(have_image Planet9 thermograph4)
	(have_image Phenomenon10 spectrograph1)
	(have_image Phenomenon10 spectrograph3)
	(have_image Phenomenon11 spectrograph1)
	(have_image Phenomenon11 spectrograph3)
))

)
