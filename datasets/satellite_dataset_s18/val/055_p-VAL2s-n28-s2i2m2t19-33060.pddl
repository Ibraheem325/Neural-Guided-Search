(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	thermograph1 - mode
	spectrograph0 - mode
	Star6 - direction
	Star7 - direction
	Star11 - direction
	Star14 - direction
	GroundStation15 - direction
	Star17 - direction
	Star18 - direction
	GroundStation13 - direction
	Star4 - direction
	Star3 - direction
	Star9 - direction
	GroundStation10 - direction
	Star1 - direction
	Star0 - direction
	GroundStation12 - direction
	Star2 - direction
	GroundStation8 - direction
	Star16 - direction
	GroundStation5 - direction
	Planet19 - direction
	Star20 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 GroundStation13)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation8)
	(supports instrument1 spectrograph0)
	(supports instrument1 thermograph1)
	(calibration_target instrument1 GroundStation12)
	(calibration_target instrument1 Star16)
	(calibration_target instrument1 Star0)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 Star9)
	(supports instrument2 spectrograph0)
	(supports instrument2 thermograph1)
	(calibration_target instrument2 GroundStation5)
	(calibration_target instrument2 Star16)
	(calibration_target instrument2 GroundStation8)
	(calibration_target instrument2 Star2)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation12)
)
(:goal (and
	(have_image Planet19 thermograph1)
	(have_image Star20 thermograph1)
))

)
