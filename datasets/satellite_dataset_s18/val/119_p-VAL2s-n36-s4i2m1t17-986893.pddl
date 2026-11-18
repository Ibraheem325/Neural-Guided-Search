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
	thermograph0 - mode
	Star2 - direction
	Star5 - direction
	Star6 - direction
	Star8 - direction
	Star10 - direction
	Star11 - direction
	Star15 - direction
	GroundStation16 - direction
	GroundStation12 - direction
	GroundStation0 - direction
	Star4 - direction
	GroundStation7 - direction
	GroundStation13 - direction
	Star9 - direction
	Star14 - direction
	Star3 - direction
	GroundStation1 - direction
	Planet17 - direction
	Planet18 - direction
	Star19 - direction
	Star20 - direction
	Star21 - direction
	Planet22 - direction
	Star23 - direction
	Phenomenon24 - direction
	Planet25 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 Star14)
	(calibration_target instrument0 GroundStation16)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet25)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 GroundStation0)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon24)
	(supports instrument2 thermograph0)
	(calibration_target instrument2 Star9)
	(calibration_target instrument2 GroundStation13)
	(calibration_target instrument2 GroundStation7)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 Star14)
	(on_board instrument2 satellite2)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation0)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 GroundStation1)
	(calibration_target instrument4 Star3)
	(on_board instrument4 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation16)
)
(:goal (and
	(have_image Planet17 thermograph0)
	(have_image Planet18 thermograph0)
	(have_image Star19 thermograph0)
	(have_image Star20 thermograph0)
	(have_image Star21 thermograph0)
	(have_image Planet22 thermograph0)
	(have_image Star23 thermograph0)
	(have_image Phenomenon24 thermograph0)
	(have_image Planet25 thermograph0)
))

)
