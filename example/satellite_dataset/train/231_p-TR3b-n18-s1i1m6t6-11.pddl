(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	thermograph4 - mode
	spectrograph3 - mode
	image5 - mode
	image2 - mode
	thermograph0 - mode
	Star0 - direction
	GroundStation3 - direction
	Star4 - direction
	Star5 - direction
	Star1 - direction
	Star2 - direction
	Planet6 - direction
	Phenomenon7 - direction
	Phenomenon8 - direction
	Star9 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 thermograph0)
	(supports instrument0 image5)
	(supports instrument0 spectrograph3)
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
)
(:goal (and
	(have_image Planet6 thermograph0)
	(have_image Phenomenon7 thermograph0)
	(have_image Phenomenon7 thermograph4)
	(have_image Phenomenon8 thermograph0)
	(have_image Star9 spectrograph1)
	(have_image Star9 spectrograph3)
))

)
