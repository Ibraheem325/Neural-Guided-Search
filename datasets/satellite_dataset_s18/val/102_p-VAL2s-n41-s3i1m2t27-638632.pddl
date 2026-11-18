(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	infrared0 - mode
	thermograph1 - mode
	Star0 - direction
	GroundStation1 - direction
	Star4 - direction
	GroundStation5 - direction
	Star6 - direction
	GroundStation7 - direction
	GroundStation11 - direction
	GroundStation18 - direction
	GroundStation20 - direction
	Star23 - direction
	GroundStation24 - direction
	Star25 - direction
	GroundStation14 - direction
	Star16 - direction
	GroundStation10 - direction
	GroundStation21 - direction
	Star13 - direction
	GroundStation2 - direction
	Star9 - direction
	GroundStation22 - direction
	Star8 - direction
	Star19 - direction
	Star15 - direction
	GroundStation17 - direction
	GroundStation12 - direction
	Star26 - direction
	GroundStation3 - direction
	Phenomenon27 - direction
	Star28 - direction
	Star29 - direction
	Planet30 - direction
	Phenomenon31 - direction
	Star32 - direction
)
(:init
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 Star16)
	(calibration_target instrument0 GroundStation14)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
	(supports instrument1 thermograph1)
	(supports instrument1 infrared0)
	(calibration_target instrument1 GroundStation12)
	(calibration_target instrument1 Star26)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 GroundStation2)
	(calibration_target instrument1 GroundStation17)
	(calibration_target instrument1 Star13)
	(calibration_target instrument1 Star19)
	(calibration_target instrument1 GroundStation21)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation1)
	(supports instrument2 infrared0)
	(supports instrument2 thermograph1)
	(calibration_target instrument2 GroundStation3)
	(calibration_target instrument2 Star26)
	(calibration_target instrument2 GroundStation12)
	(calibration_target instrument2 GroundStation17)
	(calibration_target instrument2 Star15)
	(calibration_target instrument2 Star19)
	(calibration_target instrument2 Star8)
	(calibration_target instrument2 GroundStation22)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation7)
)
(:goal (and
	(pointing satellite1 GroundStation10)
	(have_image Phenomenon27 infrared0)
	(have_image Star28 thermograph1)
	(have_image Star29 thermograph1)
	(have_image Planet30 infrared0)
	(have_image Phenomenon31 infrared0)
	(have_image Star32 infrared0)
))

)
