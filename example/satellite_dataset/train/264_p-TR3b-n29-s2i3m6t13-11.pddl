(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	image5 - mode
	thermograph4 - mode
	spectrograph3 - mode
	thermograph0 - mode
	image2 - mode
	spectrograph1 - mode
	Star2 - direction
	Star5 - direction
	GroundStation6 - direction
	Star12 - direction
	Star4 - direction
	GroundStation9 - direction
	Star1 - direction
	Star11 - direction
	Star10 - direction
	Star0 - direction
	Star8 - direction
	Star7 - direction
	GroundStation3 - direction
	Planet13 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph4)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 Star0)
	(supports instrument1 image2)
	(supports instrument1 thermograph4)
	(calibration_target instrument1 Star11)
	(calibration_target instrument1 Star1)
	(supports instrument2 spectrograph1)
	(supports instrument2 thermograph4)
	(supports instrument2 image5)
	(calibration_target instrument2 Star10)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon15)
	(supports instrument3 spectrograph1)
	(supports instrument3 image5)
	(supports instrument3 thermograph0)
	(supports instrument3 spectrograph3)
	(calibration_target instrument3 GroundStation3)
	(calibration_target instrument3 Star7)
	(calibration_target instrument3 Star8)
	(calibration_target instrument3 Star0)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star4)
)
(:goal (and
	(pointing satellite0 Star2)
	(pointing satellite1 Planet13)
	(have_image Planet13 image2)
	(have_image Planet13 thermograph0)
	(have_image Planet14 spectrograph1)
	(have_image Planet14 spectrograph3)
	(have_image Phenomenon15 spectrograph3)
	(have_image Phenomenon15 spectrograph1)
	(have_image Phenomenon16 image5)
))

)
