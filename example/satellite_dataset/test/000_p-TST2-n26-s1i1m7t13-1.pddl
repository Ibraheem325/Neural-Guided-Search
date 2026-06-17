(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image1 - mode
	thermograph2 - mode
	thermograph3 - mode
	image6 - mode
	thermograph0 - mode
	thermograph4 - mode
	infrared5 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	Star10 - direction
	GroundStation11 - direction
	Star12 - direction
	Star5 - direction
	Star3 - direction
	GroundStation4 - direction
	Planet13 - direction
	Phenomenon14 - direction
	Star15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 image6)
	(supports instrument0 infrared5)
	(supports instrument0 thermograph4)
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph3)
	(supports instrument0 thermograph2)
	(supports instrument0 image1)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 Star5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
)
(:goal (and
	(have_image Planet13 thermograph4)
	(have_image Planet13 thermograph2)
	(have_image Phenomenon14 thermograph3)
	(have_image Star15 infrared5)
	(have_image Star15 image1)
	(have_image Phenomenon16 thermograph0)
))

)
