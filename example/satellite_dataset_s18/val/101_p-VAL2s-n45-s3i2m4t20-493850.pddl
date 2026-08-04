(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	instrument5 - instrument
	thermograph1 - mode
	image3 - mode
	image0 - mode
	spectrograph2 - mode
	Star1 - direction
	GroundStation2 - direction
	Star4 - direction
	GroundStation8 - direction
	GroundStation10 - direction
	Star14 - direction
	GroundStation15 - direction
	GroundStation17 - direction
	GroundStation19 - direction
	GroundStation16 - direction
	Star12 - direction
	Star13 - direction
	Star7 - direction
	Star11 - direction
	Star3 - direction
	GroundStation5 - direction
	GroundStation0 - direction
	GroundStation6 - direction
	GroundStation9 - direction
	Star18 - direction
	Phenomenon20 - direction
	Planet21 - direction
	Phenomenon22 - direction
	Phenomenon23 - direction
	Planet24 - direction
	Star25 - direction
	Star26 - direction
	Star27 - direction
	Phenomenon28 - direction
	Star29 - direction
	Planet30 - direction
	Phenomenon31 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 image0)
	(calibration_target instrument0 Star12)
	(calibration_target instrument0 GroundStation16)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 spectrograph2)
	(supports instrument1 image3)
	(supports instrument1 image0)
	(calibration_target instrument1 Star13)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon23)
	(supports instrument2 spectrograph2)
	(supports instrument2 image0)
	(calibration_target instrument2 Star11)
	(calibration_target instrument2 Star7)
	(calibration_target instrument2 Star13)
	(supports instrument3 spectrograph2)
	(supports instrument3 thermograph1)
	(calibration_target instrument3 Star3)
	(calibration_target instrument3 GroundStation0)
	(calibration_target instrument3 GroundStation6)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation16)
	(supports instrument4 thermograph1)
	(supports instrument4 image3)
	(calibration_target instrument4 GroundStation5)
	(supports instrument5 image3)
	(supports instrument5 spectrograph2)
	(supports instrument5 image0)
	(calibration_target instrument5 Star18)
	(calibration_target instrument5 GroundStation9)
	(calibration_target instrument5 GroundStation6)
	(calibration_target instrument5 GroundStation0)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star3)
)
(:goal (and
	(have_image Phenomenon20 spectrograph2)
	(have_image Planet21 image0)
	(have_image Phenomenon22 image3)
	(have_image Phenomenon23 image0)
	(have_image Planet24 spectrograph2)
	(have_image Star25 spectrograph2)
	(have_image Star26 spectrograph2)
	(have_image Star27 image3)
	(have_image Phenomenon28 image3)
	(have_image Star29 image3)
	(have_image Planet30 image3)
	(have_image Phenomenon31 thermograph1)
))

)
