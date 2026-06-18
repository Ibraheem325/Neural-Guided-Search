(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	instrument4 - instrument
	thermograph2 - mode
	image1 - mode
	thermograph3 - mode
	infrared5 - mode
	thermograph4 - mode
	thermograph0 - mode
	Star0 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	GroundStation9 - direction
	Star3 - direction
	GroundStation2 - direction
	GroundStation1 - direction
	GroundStation11 - direction
	GroundStation7 - direction
	GroundStation5 - direction
	Star8 - direction
	GroundStation10 - direction
	Phenomenon12 - direction
	Star13 - direction
	Star14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 infrared5)
	(supports instrument0 image1)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 GroundStation5)
	(supports instrument1 thermograph0)
	(supports instrument1 thermograph3)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 GroundStation1)
	(calibration_target instrument1 Star8)
	(supports instrument2 image1)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 Star3)
	(supports instrument3 image1)
	(supports instrument3 thermograph3)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 GroundStation5)
	(calibration_target instrument3 GroundStation7)
	(calibration_target instrument3 GroundStation11)
	(calibration_target instrument3 GroundStation1)
	(supports instrument4 thermograph0)
	(supports instrument4 thermograph2)
	(calibration_target instrument4 GroundStation10)
	(calibration_target instrument4 Star8)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(on_board instrument4 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon12)
)
(:goal (and
	(pointing satellite0 Star14)
	(have_image Phenomenon12 thermograph0)
	(have_image Star13 thermograph2)
	(have_image Star13 infrared5)
	(have_image Star14 infrared5)
	(have_image Planet15 thermograph2)
	(have_image Planet15 thermograph0)
))

)
