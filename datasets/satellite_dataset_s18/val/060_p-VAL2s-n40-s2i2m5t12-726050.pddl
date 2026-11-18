(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	spectrograph1 - mode
	thermograph3 - mode
	infrared0 - mode
	spectrograph4 - mode
	spectrograph2 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	Star3 - direction
	Star4 - direction
	GroundStation6 - direction
	Star9 - direction
	GroundStation11 - direction
	GroundStation10 - direction
	GroundStation2 - direction
	GroundStation8 - direction
	GroundStation5 - direction
	GroundStation7 - direction
	Phenomenon12 - direction
	Planet13 - direction
	Star14 - direction
	Star15 - direction
	Star16 - direction
	Planet17 - direction
	Star18 - direction
	Star19 - direction
	Phenomenon20 - direction
	Star21 - direction
	Phenomenon22 - direction
	Phenomenon23 - direction
	Planet24 - direction
	Star25 - direction
	Phenomenon26 - direction
	Planet27 - direction
	Star28 - direction
	Phenomenon29 - direction
	Star30 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 GroundStation10)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon22)
	(supports instrument1 spectrograph2)
	(supports instrument1 infrared0)
	(supports instrument1 spectrograph1)
	(supports instrument1 spectrograph4)
	(supports instrument1 thermograph3)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 GroundStation5)
	(calibration_target instrument1 GroundStation8)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star9)
)
(:goal (and
	(pointing satellite1 Star19)
	(have_image Phenomenon12 infrared0)
	(have_image Planet13 thermograph3)
	(have_image Star14 spectrograph1)
	(have_image Star15 spectrograph4)
	(have_image Star16 spectrograph4)
	(have_image Planet17 spectrograph4)
	(have_image Star18 spectrograph2)
	(have_image Star19 infrared0)
	(have_image Phenomenon20 spectrograph1)
	(have_image Star21 spectrograph1)
	(have_image Phenomenon22 spectrograph2)
	(have_image Phenomenon23 infrared0)
	(have_image Planet24 spectrograph1)
	(have_image Star25 spectrograph1)
	(have_image Phenomenon26 spectrograph4)
	(have_image Planet27 thermograph3)
	(have_image Star28 spectrograph1)
	(have_image Phenomenon29 thermograph3)
	(have_image Star30 spectrograph2)
))

)
