(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	image2 - mode
	image5 - mode
	spectrograph1 - mode
	thermograph4 - mode
	spectrograph3 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star4 - direction
	Star5 - direction
	Star7 - direction
	GroundStation9 - direction
	Star8 - direction
	GroundStation6 - direction
	Star10 - direction
	Phenomenon11 - direction
	Star12 - direction
	Planet13 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 thermograph0)
	(supports instrument0 spectrograph3)
	(supports instrument0 spectrograph1)
	(supports instrument0 image5)
	(supports instrument0 image2)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 Star8)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(have_image Star10 spectrograph1)
	(have_image Star10 thermograph4)
	(have_image Phenomenon11 spectrograph1)
	(have_image Star12 spectrograph3)
	(have_image Planet13 thermograph0)
	(have_image Planet13 image2)
))

)
