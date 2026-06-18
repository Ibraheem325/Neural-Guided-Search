(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph3 - mode
	thermograph4 - mode
	spectrograph1 - mode
	image2 - mode
	image5 - mode
	thermograph0 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	Star5 - direction
	Star7 - direction
	Star8 - direction
	Star10 - direction
	Star11 - direction
	Star12 - direction
	GroundStation13 - direction
	GroundStation6 - direction
	Star4 - direction
	GroundStation3 - direction
	GroundStation9 - direction
	Planet14 - direction
	Planet15 - direction
	Phenomenon16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 spectrograph3)
	(supports instrument0 image2)
	(supports instrument0 image5)
	(supports instrument0 spectrograph1)
	(supports instrument0 thermograph4)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 GroundStation6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
)
(:goal (and
	(pointing satellite0 Planet14)
	(have_image Planet14 thermograph0)
	(have_image Planet14 spectrograph3)
	(have_image Planet15 thermograph4)
	(have_image Planet15 thermograph0)
	(have_image Phenomenon16 thermograph0)
	(have_image Phenomenon17 thermograph0)
))

)
