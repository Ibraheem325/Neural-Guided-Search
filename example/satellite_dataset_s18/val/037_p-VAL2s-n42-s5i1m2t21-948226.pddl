(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	spectrograph1 - mode
	thermograph0 - mode
	GroundStation4 - direction
	GroundStation7 - direction
	GroundStation10 - direction
	GroundStation13 - direction
	GroundStation14 - direction
	GroundStation15 - direction
	GroundStation16 - direction
	GroundStation17 - direction
	Star18 - direction
	GroundStation19 - direction
	GroundStation20 - direction
	GroundStation8 - direction
	GroundStation12 - direction
	Star5 - direction
	GroundStation9 - direction
	GroundStation2 - direction
	GroundStation6 - direction
	GroundStation11 - direction
	Star3 - direction
	Star1 - direction
	Star0 - direction
	Planet21 - direction
	Phenomenon22 - direction
	Planet23 - direction
	Star24 - direction
	Star25 - direction
	Star26 - direction
	Planet27 - direction
	Planet28 - direction
	Phenomenon29 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 GroundStation8)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation11)
	(supports instrument1 thermograph0)
	(supports instrument1 spectrograph1)
	(calibration_target instrument1 GroundStation12)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star24)
	(supports instrument2 thermograph0)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 GroundStation9)
	(calibration_target instrument2 Star0)
	(calibration_target instrument2 Star5)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star1)
	(supports instrument3 spectrograph1)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 Star1)
	(calibration_target instrument3 Star3)
	(calibration_target instrument3 GroundStation11)
	(calibration_target instrument3 GroundStation6)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Phenomenon29)
	(supports instrument4 spectrograph1)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 Star0)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation10)
)
(:goal (and
	(pointing satellite4 GroundStation4)
	(have_image Planet21 spectrograph1)
	(have_image Phenomenon22 thermograph0)
	(have_image Planet23 thermograph0)
	(have_image Star24 thermograph0)
	(have_image Star25 thermograph0)
	(have_image Star26 spectrograph1)
	(have_image Planet27 spectrograph1)
	(have_image Planet28 thermograph0)
	(have_image Phenomenon29 thermograph0)
))

)
