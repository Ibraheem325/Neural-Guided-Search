(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image3 - mode
	thermograph0 - mode
	infrared2 - mode
	infrared1 - mode
	Star0 - direction
	GroundStation2 - direction
	Star3 - direction
	Star4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation8 - direction
	GroundStation10 - direction
	Star11 - direction
	Star12 - direction
	Star13 - direction
	GroundStation1 - direction
	Star7 - direction
	Star9 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Planet16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 infrared1)
	(supports instrument0 image3)
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation10)
)
(:goal (and
	(pointing satellite0 GroundStation8)
	(have_image Phenomenon14 infrared2)
	(have_image Phenomenon15 infrared1)
	(have_image Planet16 image3)
	(have_image Phenomenon17 infrared2)
))

)
