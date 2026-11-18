(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	thermograph0 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	Star2 - direction
	Star3 - direction
	Star4 - direction
	GroundStation5 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation9 - direction
	Star10 - direction
	GroundStation11 - direction
	Star12 - direction
	GroundStation13 - direction
	GroundStation14 - direction
	GroundStation16 - direction
	Star17 - direction
	Star20 - direction
	GroundStation21 - direction
	Star23 - direction
	GroundStation24 - direction
	GroundStation25 - direction
	GroundStation27 - direction
	GroundStation28 - direction
	Star30 - direction
	GroundStation31 - direction
	Star33 - direction
	GroundStation34 - direction
	GroundStation35 - direction
	Star36 - direction
	Star37 - direction
	GroundStation38 - direction
	Star39 - direction
	GroundStation41 - direction
	Star29 - direction
	GroundStation15 - direction
	GroundStation22 - direction
	GroundStation19 - direction
	Star40 - direction
	GroundStation32 - direction
	GroundStation26 - direction
	GroundStation18 - direction
	Phenomenon42 - direction
	Planet43 - direction
	Planet44 - direction
	Star45 - direction
	Star46 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation19)
	(calibration_target instrument0 GroundStation22)
	(calibration_target instrument0 GroundStation15)
	(calibration_target instrument0 Star29)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 GroundStation18)
	(calibration_target instrument1 GroundStation26)
	(calibration_target instrument1 GroundStation32)
	(calibration_target instrument1 Star40)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation24)
)
(:goal (and
	(pointing satellite0 Star12)
	(have_image Phenomenon42 thermograph0)
	(have_image Planet43 thermograph0)
	(have_image Planet44 thermograph0)
	(have_image Star45 thermograph0)
	(have_image Star46 thermograph0)
))

)
