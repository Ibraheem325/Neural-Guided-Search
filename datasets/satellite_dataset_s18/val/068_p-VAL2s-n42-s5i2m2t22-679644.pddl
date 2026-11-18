(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	instrument3 - instrument
	satellite3 - satellite
	instrument4 - instrument
	satellite4 - satellite
	instrument5 - instrument
	thermograph1 - mode
	spectrograph0 - mode
	Star0 - direction
	Star3 - direction
	Star4 - direction
	GroundStation8 - direction
	GroundStation10 - direction
	GroundStation12 - direction
	GroundStation20 - direction
	Star21 - direction
	GroundStation19 - direction
	GroundStation16 - direction
	Star15 - direction
	Star7 - direction
	GroundStation9 - direction
	GroundStation18 - direction
	Star14 - direction
	GroundStation5 - direction
	GroundStation17 - direction
	GroundStation11 - direction
	GroundStation2 - direction
	Star13 - direction
	GroundStation6 - direction
	Star1 - direction
	Phenomenon22 - direction
	Star23 - direction
	Phenomenon24 - direction
	Planet25 - direction
	Star26 - direction
	Star27 - direction
	Phenomenon28 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation19)
	(calibration_target instrument0 GroundStation16)
	(calibration_target instrument0 GroundStation2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star7)
	(supports instrument1 spectrograph0)
	(supports instrument1 thermograph1)
	(calibration_target instrument1 Star14)
	(calibration_target instrument1 GroundStation5)
	(calibration_target instrument1 GroundStation16)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star14)
	(supports instrument2 spectrograph0)
	(supports instrument2 thermograph1)
	(calibration_target instrument2 GroundStation18)
	(calibration_target instrument2 Star14)
	(calibration_target instrument2 GroundStation9)
	(calibration_target instrument2 Star7)
	(calibration_target instrument2 Star15)
	(supports instrument3 thermograph1)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 GroundStation5)
	(calibration_target instrument3 Star14)
	(on_board instrument2 satellite2)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star26)
	(supports instrument4 spectrograph0)
	(supports instrument4 thermograph1)
	(calibration_target instrument4 Star13)
	(calibration_target instrument4 GroundStation2)
	(calibration_target instrument4 GroundStation11)
	(calibration_target instrument4 GroundStation17)
	(calibration_target instrument4 GroundStation5)
	(on_board instrument4 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star4)
	(supports instrument5 spectrograph0)
	(supports instrument5 thermograph1)
	(calibration_target instrument5 Star1)
	(calibration_target instrument5 GroundStation6)
	(on_board instrument5 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star0)
)
(:goal (and
	(pointing satellite0 GroundStation20)
	(pointing satellite2 Star3)
	(have_image Phenomenon22 thermograph1)
	(have_image Star23 spectrograph0)
	(have_image Phenomenon24 thermograph1)
	(have_image Planet25 thermograph1)
	(have_image Star26 spectrograph0)
	(have_image Star27 spectrograph0)
	(have_image Phenomenon28 spectrograph0)
))

)
