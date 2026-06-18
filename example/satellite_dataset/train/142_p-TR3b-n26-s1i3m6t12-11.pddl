(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	spectrograph3 - mode
	image5 - mode
	image2 - mode
	thermograph4 - mode
	spectrograph1 - mode
	thermograph0 - mode
	Star0 - direction
	Star1 - direction
	GroundStation3 - direction
	Star5 - direction
	GroundStation6 - direction
	Star8 - direction
	GroundStation9 - direction
	Star11 - direction
	Star2 - direction
	Star7 - direction
	Star10 - direction
	Star4 - direction
	Phenomenon12 - direction
	Planet13 - direction
	Phenomenon14 - direction
	Star15 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 thermograph4)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 Star2)
	(supports instrument1 image5)
	(supports instrument1 thermograph0)
	(supports instrument1 image2)
	(supports instrument1 spectrograph3)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 Star10)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
)
(:goal (and
	(pointing satellite0 Phenomenon14)
	(have_image Phenomenon12 spectrograph3)
	(have_image Planet13 spectrograph1)
	(have_image Phenomenon14 spectrograph3)
	(have_image Phenomenon14 spectrograph1)
	(have_image Star15 thermograph4)
))

)
