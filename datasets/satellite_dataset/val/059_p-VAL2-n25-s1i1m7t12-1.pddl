(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image1 - mode
	infrared5 - mode
	thermograph2 - mode
	image6 - mode
	thermograph4 - mode
	thermograph3 - mode
	thermograph0 - mode
	GroundStation0 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	Star10 - direction
	GroundStation11 - direction
	Star1 - direction
	Star3 - direction
	Star12 - direction
	Star13 - direction
	Planet14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 image6)
	(supports instrument0 thermograph2)
	(supports instrument0 thermograph3)
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph4)
	(supports instrument0 infrared5)
	(supports instrument0 image1)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet15)
)
(:goal (and
	(have_image Star12 thermograph2)
	(have_image Star13 image1)
	(have_image Star13 image6)
	(have_image Planet14 thermograph4)
	(have_image Planet14 thermograph3)
	(have_image Planet15 thermograph3)
))

)
