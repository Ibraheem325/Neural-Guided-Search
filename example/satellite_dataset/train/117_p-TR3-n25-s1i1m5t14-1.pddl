(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph4 - mode
	thermograph0 - mode
	thermograph3 - mode
	thermograph2 - mode
	image1 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	Star9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	Star4 - direction
	GroundStation13 - direction
	Star8 - direction
	Phenomenon14 - direction
	Planet15 - direction
	Star16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 image1)
	(supports instrument0 thermograph3)
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph4)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 GroundStation13)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation7)
)
(:goal (and
	(have_image Phenomenon14 thermograph2)
	(have_image Planet15 thermograph0)
	(have_image Star16 thermograph4)
	(have_image Planet17 thermograph3)
))

)
