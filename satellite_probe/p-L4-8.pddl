(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	image0 - mode
	thermograph2 - mode
	thermograph1 - mode
	infrared3 - mode
	Star4 - direction
	Star8 - direction
	GroundStation10 - direction
	Star13 - direction
	GroundStation16 - direction
	Star19 - direction
	GroundStation20 - direction
	GroundStation21 - direction
	GroundStation5 - direction
	GroundStation3 - direction
	Star18 - direction
	GroundStation9 - direction
	Star15 - direction
	GroundStation22 - direction
	Star6 - direction
	GroundStation17 - direction
	Star7 - direction
	GroundStation12 - direction
	GroundStation2 - direction
	GroundStation11 - direction
	GroundStation14 - direction
	Star24 - direction
	GroundStation0 - direction
	GroundStation1 - direction
	Star23 - direction
	Planet25 - direction
	Planet26 - direction
	Planet27 - direction
	Planet28 - direction
	Planet29 - direction
	Phenomenon30 - direction
	Phenomenon31 - direction
	Star32 - direction
	Planet33 - direction
	Phenomenon34 - direction
	Planet35 - direction
	Planet36 - direction
	Phenomenon37 - direction
	Star38 - direction
	Phenomenon39 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 GroundStation11)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 thermograph2)
	(calibration_target instrument1 Star6)
	(calibration_target instrument1 GroundStation1)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 Star18)
	(calibration_target instrument1 GroundStation3)
	(calibration_target instrument1 GroundStation5)
	(supports instrument2 thermograph1)
	(supports instrument2 infrared3)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 GroundStation17)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 Star6)
	(calibration_target instrument2 GroundStation22)
	(calibration_target instrument2 Star15)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet27)
	(supports instrument3 infrared3)
	(calibration_target instrument3 GroundStation2)
	(calibration_target instrument3 GroundStation12)
	(calibration_target instrument3 Star7)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation20)
	(supports instrument4 thermograph1)
	(supports instrument4 thermograph2)
	(supports instrument4 image0)
	(calibration_target instrument4 Star23)
	(calibration_target instrument4 GroundStation1)
	(calibration_target instrument4 GroundStation0)
	(calibration_target instrument4 Star24)
	(calibration_target instrument4 GroundStation14)
	(calibration_target instrument4 GroundStation11)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation0)
)
(:goal (and
	(pointing satellite0 GroundStation14)
	(have_image Planet25 image0)
	(have_image Planet26 thermograph1)
	(have_image Planet27 thermograph1)
	(have_image Planet28 thermograph2)
	(have_image Planet29 thermograph2)
	(have_image Phenomenon30 infrared3)
	(have_image Phenomenon31 infrared3)
	(have_image Star32 thermograph2)
	(have_image Planet33 thermograph1)
	(have_image Phenomenon34 thermograph1)
	(have_image Planet35 thermograph2)
	(have_image Planet36 image0)
	(have_image Phenomenon37 thermograph2)
	(have_image Star38 image0)
	(have_image Phenomenon39 infrared3)
))

)
