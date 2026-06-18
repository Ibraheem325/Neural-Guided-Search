(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	infrared5 - mode
	image1 - mode
	thermograph3 - mode
	image6 - mode
	thermograph2 - mode
	thermograph4 - mode
	thermograph0 - mode
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation7 - direction
	GroundStation9 - direction
	Star10 - direction
	GroundStation11 - direction
	Star12 - direction
	GroundStation13 - direction
	Star6 - direction
	GroundStation0 - direction
	GroundStation8 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 image6)
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 GroundStation13)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon14)
	(supports instrument1 image1)
	(supports instrument1 thermograph4)
	(supports instrument1 thermograph3)
	(supports instrument1 infrared5)
	(calibration_target instrument1 GroundStation8)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon14)
)
(:goal (and
	(pointing satellite1 GroundStation7)
	(have_image Phenomenon14 infrared5)
	(have_image Phenomenon15 thermograph4)
	(have_image Phenomenon15 thermograph3)
	(have_image Star16 thermograph3)
	(have_image Star16 thermograph0)
	(have_image Star17 image6)
	(have_image Star17 thermograph0)
))

)
