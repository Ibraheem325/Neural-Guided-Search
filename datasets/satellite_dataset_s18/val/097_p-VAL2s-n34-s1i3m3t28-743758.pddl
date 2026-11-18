(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	image1 - mode
	thermograph2 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation9 - direction
	Star10 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	GroundStation13 - direction
	GroundStation14 - direction
	Star15 - direction
	GroundStation16 - direction
	Star17 - direction
	GroundStation18 - direction
	Star19 - direction
	Star20 - direction
	GroundStation21 - direction
	Star22 - direction
	Star23 - direction
	GroundStation24 - direction
	Star27 - direction
	Star26 - direction
	GroundStation25 - direction
	Star28 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 thermograph2)
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation25)
	(calibration_target instrument0 Star26)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
)
(:goal (and
	(have_image Star28 image1)
))

)
