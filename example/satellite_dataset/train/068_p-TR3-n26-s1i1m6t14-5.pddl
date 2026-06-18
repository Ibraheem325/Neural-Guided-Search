(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph2 - mode
	infrared4 - mode
	infrared3 - mode
	infrared5 - mode
	image0 - mode
	infrared1 - mode
	Star0 - direction
	Star2 - direction
	Star3 - direction
	Star4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	Star13 - direction
	GroundStation1 - direction
	GroundStation9 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 infrared1)
	(supports instrument0 image0)
	(supports instrument0 infrared5)
	(supports instrument0 infrared3)
	(supports instrument0 infrared4)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation12)
)
(:goal (and
	(have_image Planet14 infrared3)
	(have_image Planet14 image0)
	(have_image Phenomenon15 infrared3)
	(have_image Star16 infrared1)
	(have_image Star17 image0)
))

)
