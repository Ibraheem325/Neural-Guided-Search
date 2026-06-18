(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image1 - mode
	thermograph0 - mode
	infrared2 - mode
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	Star4 - direction
	GroundStation5 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation9 - direction
	Star10 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	GroundStation13 - direction
	Star0 - direction
	Planet14 - direction
	Star15 - direction
	Star16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 infrared2)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star10)
)
(:goal (and
	(pointing satellite0 GroundStation9)
	(have_image Planet14 image1)
	(have_image Star15 image1)
	(have_image Star16 infrared2)
	(have_image Planet17 thermograph0)
))

)
