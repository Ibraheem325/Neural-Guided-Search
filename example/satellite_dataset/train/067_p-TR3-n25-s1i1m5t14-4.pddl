(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared1 - mode
	thermograph0 - mode
	infrared2 - mode
	infrared4 - mode
	image3 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star9 - direction
	Star10 - direction
	GroundStation11 - direction
	Star12 - direction
	GroundStation13 - direction
	Star6 - direction
	Star14 - direction
	Star15 - direction
	Phenomenon16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 infrared2)
	(supports instrument0 image3)
	(supports instrument0 infrared4)
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 GroundStation13)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(pointing satellite0 Star14)
	(have_image Star14 infrared1)
	(have_image Star15 thermograph0)
	(have_image Phenomenon16 infrared1)
	(have_image Star17 image3)
))

)
