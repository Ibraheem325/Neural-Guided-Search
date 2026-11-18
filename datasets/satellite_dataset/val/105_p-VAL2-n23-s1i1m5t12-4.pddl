(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image3 - mode
	infrared2 - mode
	thermograph0 - mode
	infrared1 - mode
	infrared4 - mode
	Star0 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star9 - direction
	Star10 - direction
	GroundStation11 - direction
	Star1 - direction
	Star6 - direction
	Phenomenon12 - direction
	Star13 - direction
	Star14 - direction
	Star15 - direction
)
(:init
	(supports instrument0 image3)
	(supports instrument0 thermograph0)
	(supports instrument0 infrared4)
	(supports instrument0 infrared1)
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
)
(:goal (and
	(have_image Phenomenon12 image3)
	(have_image Star13 thermograph0)
	(have_image Star14 infrared1)
	(have_image Star15 infrared4)
))

)
