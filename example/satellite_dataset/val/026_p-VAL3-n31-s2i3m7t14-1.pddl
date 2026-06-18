(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	thermograph2 - mode
	image6 - mode
	thermograph3 - mode
	infrared5 - mode
	image1 - mode
	thermograph4 - mode
	thermograph0 - mode
	Star1 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	GroundStation7 - direction
	GroundStation9 - direction
	Star12 - direction
	GroundStation0 - direction
	GroundStation8 - direction
	Star5 - direction
	GroundStation11 - direction
	Star10 - direction
	Star3 - direction
	GroundStation13 - direction
	Star6 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 image6)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 GroundStation13)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon14)
	(supports instrument1 image1)
	(calibration_target instrument1 GroundStation8)
	(supports instrument2 thermograph3)
	(supports instrument2 thermograph2)
	(supports instrument2 thermograph0)
	(supports instrument2 thermograph4)
	(supports instrument2 infrared5)
	(calibration_target instrument2 Star10)
	(calibration_target instrument2 GroundStation11)
	(calibration_target instrument2 Star5)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 Star6)
	(calibration_target instrument3 GroundStation13)
	(calibration_target instrument3 Star3)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
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
