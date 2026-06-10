(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	thermograph0 - mode
	thermograph2 - mode
	image1 - mode
	thermograph3 - mode
	GroundStation0 - direction
	Star2 - direction
	GroundStation5 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	Star12 - direction
	GroundStation13 - direction
	Star15 - direction
	Star16 - direction
	Star17 - direction
	GroundStation19 - direction
	Star14 - direction
	GroundStation3 - direction
	GroundStation1 - direction
	Star6 - direction
	Star18 - direction
	GroundStation4 - direction
	Star20 - direction
	Planet21 - direction
	Phenomenon22 - direction
	Planet23 - direction
	Planet24 - direction
	Star25 - direction
	Phenomenon26 - direction
	Planet27 - direction
	Star28 - direction
	Phenomenon29 - direction
	Star30 - direction
	Phenomenon31 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 Star14)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star25)
	(supports instrument1 thermograph3)
	(supports instrument1 image1)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 GroundStation4)
	(calibration_target instrument1 Star18)
	(calibration_target instrument1 Star6)
	(calibration_target instrument1 GroundStation1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star30)
)
(:goal (and
	(pointing satellite0 GroundStation19)
	(pointing satellite1 GroundStation19)
	(have_image Star20 thermograph0)
	(have_image Planet21 thermograph2)
	(have_image Phenomenon22 thermograph0)
	(have_image Planet23 thermograph3)
	(have_image Planet24 image1)
	(have_image Star25 thermograph2)
	(have_image Phenomenon26 thermograph0)
	(have_image Planet27 thermograph3)
	(have_image Star28 image1)
	(have_image Phenomenon29 thermograph2)
	(have_image Star30 thermograph3)
	(have_image Phenomenon31 image1)
))

)
