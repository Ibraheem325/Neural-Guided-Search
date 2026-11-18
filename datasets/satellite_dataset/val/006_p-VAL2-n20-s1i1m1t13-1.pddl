(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	Star0 - direction
	GroundStation2 - direction
	Star4 - direction
	Star5 - direction
	Star7 - direction
	Star8 - direction
	Star10 - direction
	Star11 - direction
	Star12 - direction
	Star9 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	GroundStation6 - direction
	Planet13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Planet16 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 Star9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet16)
)
(:goal (and
	(pointing satellite0 Star7)
	(have_image Planet13 thermograph0)
	(have_image Phenomenon14 thermograph0)
	(have_image Phenomenon15 thermograph0)
	(have_image Planet16 thermograph0)
))

)
