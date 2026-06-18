(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image2 - mode
	spectrograph3 - mode
	thermograph0 - mode
	thermograph4 - mode
	image5 - mode
	spectrograph1 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	Star4 - direction
	Star5 - direction
	GroundStation6 - direction
	Star8 - direction
	Star10 - direction
	GroundStation3 - direction
	GroundStation9 - direction
	Star7 - direction
	Phenomenon11 - direction
	Phenomenon12 - direction
	Phenomenon13 - direction
	Planet14 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 image2)
	(supports instrument0 image5)
	(supports instrument0 thermograph4)
	(supports instrument0 thermograph0)
	(supports instrument0 spectrograph3)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon13)
)
(:goal (and
	(pointing satellite0 Star10)
	(have_image Phenomenon11 image2)
	(have_image Phenomenon11 spectrograph1)
	(have_image Phenomenon12 thermograph0)
	(have_image Phenomenon13 spectrograph1)
	(have_image Phenomenon13 spectrograph3)
	(have_image Planet14 image5)
))

)
