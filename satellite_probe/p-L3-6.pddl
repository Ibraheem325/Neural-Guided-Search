(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	infrared0 - mode
	image3 - mode
	thermograph1 - mode
	thermograph2 - mode
	Star0 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	Star7 - direction
	GroundStation10 - direction
	Star12 - direction
	GroundStation13 - direction
	GroundStation14 - direction
	GroundStation15 - direction
	Star16 - direction
	Star17 - direction
	GroundStation19 - direction
	Star1 - direction
	GroundStation18 - direction
	Star8 - direction
	Star11 - direction
	Star9 - direction
	Star20 - direction
	Star21 - direction
	Planet22 - direction
	Phenomenon23 - direction
	Star24 - direction
	Phenomenon25 - direction
	Phenomenon26 - direction
	Star27 - direction
	Star28 - direction
	Phenomenon29 - direction
	Planet30 - direction
	Phenomenon31 - direction
)
(:init
	(supports instrument0 image3)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation18)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star7)
	(supports instrument1 thermograph1)
	(calibration_target instrument1 Star1)
	(supports instrument2 image3)
	(supports instrument2 thermograph1)
	(calibration_target instrument2 Star9)
	(calibration_target instrument2 Star11)
	(calibration_target instrument2 Star8)
	(calibration_target instrument2 GroundStation18)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation14)
)
(:goal (and
	(have_image Star20 thermograph1)
	(have_image Star21 image3)
	(have_image Planet22 image3)
	(have_image Phenomenon23 thermograph1)
	(have_image Star24 image3)
	(have_image Phenomenon25 image3)
	(have_image Phenomenon26 thermograph2)
	(have_image Star27 image3)
	(have_image Star28 thermograph2)
	(have_image Phenomenon29 thermograph2)
	(have_image Planet30 thermograph2)
	(have_image Phenomenon31 thermograph1)
))

)
