(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	infrared5 - mode
	thermograph3 - mode
	image1 - mode
	thermograph2 - mode
	thermograph4 - mode
	thermograph0 - mode
	Star0 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	Star8 - direction
	GroundStation11 - direction
	GroundStation10 - direction
	GroundStation2 - direction
	GroundStation12 - direction
	GroundStation9 - direction
	GroundStation13 - direction
	GroundStation5 - direction
	GroundStation1 - direction
	Star3 - direction
	Planet14 - direction
	Star15 - direction
	Phenomenon16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph3)
	(supports instrument0 infrared5)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 GroundStation12)
	(supports instrument1 image1)
	(supports instrument1 infrared5)
	(supports instrument1 thermograph0)
	(supports instrument1 thermograph4)
	(calibration_target instrument1 GroundStation2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star3)
	(supports instrument2 infrared5)
	(supports instrument2 thermograph3)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 GroundStation13)
	(calibration_target instrument2 GroundStation9)
	(calibration_target instrument2 GroundStation12)
	(supports instrument3 thermograph0)
	(supports instrument3 thermograph3)
	(calibration_target instrument3 Star3)
	(calibration_target instrument3 GroundStation1)
	(calibration_target instrument3 GroundStation5)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation12)
)
(:goal (and
	(pointing satellite1 Planet14)
	(have_image Planet14 thermograph2)
	(have_image Star15 thermograph3)
	(have_image Phenomenon16 thermograph4)
	(have_image Phenomenon16 image1)
	(have_image Phenomenon17 thermograph4)
))

)
