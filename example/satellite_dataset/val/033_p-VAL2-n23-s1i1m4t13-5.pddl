(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph2 - mode
	infrared1 - mode
	image0 - mode
	infrared3 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star4 - direction
	Star5 - direction
	Star6 - direction
	GroundStation7 - direction
	Star8 - direction
	GroundStation10 - direction
	Star12 - direction
	Star11 - direction
	GroundStation9 - direction
	Star3 - direction
	Star13 - direction
	Phenomenon14 - direction
	Star15 - direction
	Star16 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 infrared3)
	(supports instrument0 image0)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 Star11)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
)
(:goal (and
	(have_image Star13 image0)
	(have_image Phenomenon14 infrared3)
	(have_image Star15 image0)
	(have_image Star16 infrared1)
))

)
