(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	thermograph0 - mode
	spectrograph1 - mode
	image2 - mode
	spectrograph3 - mode
	image5 - mode
	thermograph4 - mode
	Star0 - direction
	Star1 - direction
	GroundStation3 - direction
	Star5 - direction
	GroundStation6 - direction
	Star2 - direction
	Star7 - direction
	Star10 - direction
	Star4 - direction
	GroundStation9 - direction
	Star8 - direction
	Star11 - direction
	Phenomenon12 - direction
	Planet13 - direction
	Phenomenon14 - direction
	Star15 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph3)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 Star2)
	(supports instrument1 image5)
	(supports instrument1 thermograph0)
	(supports instrument1 image2)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 Star10)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
	(supports instrument2 thermograph0)
	(supports instrument2 thermograph4)
	(calibration_target instrument2 Star11)
	(calibration_target instrument2 Star8)
	(calibration_target instrument2 GroundStation9)
	(calibration_target instrument2 Star4)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star2)
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
