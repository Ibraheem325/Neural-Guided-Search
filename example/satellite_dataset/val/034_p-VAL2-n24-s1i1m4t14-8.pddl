(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared3 - mode
	thermograph1 - mode
	image0 - mode
	thermograph2 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation5 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	Star13 - direction
	Star4 - direction
	Planet14 - direction
	Star15 - direction
	Planet16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 infrared3)
	(supports instrument0 thermograph1)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
)
(:goal (and
	(have_image Planet14 infrared3)
	(have_image Star15 thermograph2)
	(have_image Planet16 infrared3)
	(have_image Star17 infrared3)
))

)
