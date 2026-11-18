(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph6 - mode
	infrared5 - mode
	spectrograph0 - mode
	infrared10 - mode
	image4 - mode
	thermograph7 - mode
	infrared1 - mode
	image3 - mode
	infrared9 - mode
	thermograph8 - mode
	image2 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	Star4 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	GroundStation8 - direction
	Star9 - direction
	Star12 - direction
	GroundStation13 - direction
	GroundStation14 - direction
	Star15 - direction
	GroundStation16 - direction
	Star17 - direction
	Star20 - direction
	GroundStation22 - direction
	Star23 - direction
	GroundStation24 - direction
	Star25 - direction
	GroundStation26 - direction
	GroundStation27 - direction
	Star2 - direction
	GroundStation10 - direction
	Star19 - direction
	GroundStation11 - direction
	Star18 - direction
	GroundStation21 - direction
	Phenomenon28 - direction
	Star29 - direction
	Planet30 - direction
	Planet31 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 thermograph7)
	(supports instrument0 infrared10)
	(supports instrument0 image2)
	(supports instrument0 thermograph8)
	(supports instrument0 infrared9)
	(supports instrument0 image3)
	(supports instrument0 image4)
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared5)
	(supports instrument0 spectrograph6)
	(calibration_target instrument0 GroundStation21)
	(calibration_target instrument0 Star18)
	(calibration_target instrument0 GroundStation11)
	(calibration_target instrument0 Star19)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star29)
)
(:goal (and
	(pointing satellite0 Planet31)
	(have_image Phenomenon28 infrared1)
	(have_image Phenomenon28 thermograph8)
	(have_image Phenomenon28 spectrograph0)
	(have_image Star29 spectrograph6)
	(have_image Star29 image4)
	(have_image Star29 infrared5)
	(have_image Planet30 infrared10)
	(have_image Planet30 infrared1)
	(have_image Planet30 image2)
	(have_image Planet31 spectrograph6)
	(have_image Planet31 infrared5)
	(have_image Planet31 infrared1)
))

)
