(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	thermograph2 - mode
	thermograph1 - mode
	image0 - mode
	Star0 - direction
	Star2 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	Star6 - direction
	Star7 - direction
	GroundStation8 - direction
	Star10 - direction
	GroundStation11 - direction
	GroundStation14 - direction
	GroundStation12 - direction
	GroundStation13 - direction
	GroundStation9 - direction
	GroundStation1 - direction
	Star3 - direction
	Planet15 - direction
	Planet16 - direction
	Phenomenon17 - direction
	Star18 - direction
	Star19 - direction
	Phenomenon20 - direction
	Star21 - direction
	Planet22 - direction
)
(:init
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 Star3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation8)
	(supports instrument1 thermograph1)
	(supports instrument1 image0)
	(calibration_target instrument1 Star3)
	(calibration_target instrument1 GroundStation1)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 GroundStation13)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation11)
)
(:goal (and
	(pointing satellite1 Star3)
	(have_image Planet15 image0)
	(have_image Planet16 image0)
	(have_image Phenomenon17 thermograph1)
	(have_image Star18 image0)
	(have_image Star19 thermograph2)
	(have_image Phenomenon20 image0)
	(have_image Star21 image0)
	(have_image Planet22 image0)
))

)
