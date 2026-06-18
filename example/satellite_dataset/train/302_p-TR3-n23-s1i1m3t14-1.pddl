(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph2 - mode
	image1 - mode
	thermograph0 - mode
	GroundStation0 - direction
	Star1 - direction
	Star3 - direction
	Star4 - direction
	Star5 - direction
	Star6 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	Star12 - direction
	GroundStation13 - direction
	GroundStation8 - direction
	GroundStation2 - direction
	Star7 - direction
	Star14 - direction
	Star15 - direction
	Planet16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 image1)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 GroundStation8)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
)
(:goal (and
	(pointing satellite0 Planet16)
	(have_image Star14 image1)
	(have_image Star15 thermograph0)
	(have_image Planet16 thermograph0)
	(have_image Star17 image1)
))

)
