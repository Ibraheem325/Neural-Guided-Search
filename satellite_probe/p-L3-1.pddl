(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	thermograph3 - mode
	thermograph0 - mode
	thermograph2 - mode
	image1 - mode
	Star2 - direction
	GroundStation3 - direction
	GroundStation5 - direction
	Star6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	Star12 - direction
	Star14 - direction
	Star16 - direction
	Star17 - direction
	Star18 - direction
	Star22 - direction
	GroundStation13 - direction
	GroundStation11 - direction
	GroundStation4 - direction
	GroundStation0 - direction
	Star23 - direction
	Star20 - direction
	GroundStation10 - direction
	GroundStation1 - direction
	Star24 - direction
	Star21 - direction
	Star15 - direction
	GroundStation19 - direction
	Star25 - direction
	Phenomenon26 - direction
	Planet27 - direction
	Phenomenon28 - direction
	Phenomenon29 - direction
	Planet30 - direction
	Planet31 - direction
	Planet32 - direction
	Phenomenon33 - direction
	Star34 - direction
	Star35 - direction
	Star36 - direction
	Planet37 - direction
	Phenomenon38 - direction
	Phenomenon39 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 Star22)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet32)
	(supports instrument1 image1)
	(supports instrument1 thermograph2)
	(supports instrument1 thermograph3)
	(calibration_target instrument1 GroundStation0)
	(calibration_target instrument1 GroundStation1)
	(calibration_target instrument1 GroundStation13)
	(calibration_target instrument1 GroundStation4)
	(calibration_target instrument1 Star22)
	(supports instrument2 image1)
	(supports instrument2 thermograph0)
	(supports instrument2 thermograph3)
	(calibration_target instrument2 Star23)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation8)
	(supports instrument3 thermograph3)
	(calibration_target instrument3 Star24)
	(calibration_target instrument3 GroundStation0)
	(calibration_target instrument3 GroundStation4)
	(calibration_target instrument3 GroundStation11)
	(calibration_target instrument3 Star23)
	(supports instrument4 image1)
	(supports instrument4 thermograph3)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 Star21)
	(calibration_target instrument4 Star24)
	(calibration_target instrument4 GroundStation1)
	(calibration_target instrument4 GroundStation10)
	(calibration_target instrument4 Star20)
	(calibration_target instrument4 Star23)
	(supports instrument5 thermograph3)
	(calibration_target instrument5 GroundStation19)
	(calibration_target instrument5 Star15)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation8)
)
(:goal (and
	(pointing satellite0 Star36)
	(pointing satellite1 Star12)
	(have_image Star25 image1)
	(have_image Phenomenon26 thermograph3)
	(have_image Planet27 thermograph3)
	(have_image Phenomenon28 image1)
	(have_image Phenomenon29 image1)
	(have_image Planet30 thermograph3)
	(have_image Planet31 thermograph0)
	(have_image Planet32 image1)
	(have_image Phenomenon33 thermograph3)
	(have_image Star34 thermograph2)
	(have_image Star35 image1)
	(have_image Star36 image1)
	(have_image Planet37 thermograph3)
	(have_image Phenomenon38 thermograph2)
	(have_image Phenomenon39 image1)
))

)
