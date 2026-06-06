(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	infrared0 - mode
	thermograph1 - mode
	thermograph2 - mode
	GroundStation2 - direction
	Star4 - direction
	Star6 - direction
	GroundStation10 - direction
	GroundStation12 - direction
	Star14 - direction
	Star0 - direction
	GroundStation1 - direction
	Star11 - direction
	Star13 - direction
	GroundStation9 - direction
	GroundStation7 - direction
	Star5 - direction
	GroundStation3 - direction
	Star8 - direction
	Phenomenon15 - direction
	Planet16 - direction
	Star17 - direction
	Star18 - direction
	Star19 - direction
	Planet20 - direction
	Planet21 - direction
	Star22 - direction
)
(:init
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star11)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 Star0)
	(supports instrument1 thermograph2)
	(calibration_target instrument1 Star13)
	(supports instrument2 infrared0)
	(supports instrument2 thermograph1)
	(calibration_target instrument2 GroundStation7)
	(calibration_target instrument2 GroundStation9)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star6)
	(supports instrument3 thermograph1)
	(calibration_target instrument3 Star8)
	(calibration_target instrument3 GroundStation3)
	(calibration_target instrument3 Star5)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation3)
)
(:goal (and
	(pointing satellite0 GroundStation2)
	(have_image Phenomenon15 thermograph1)
	(have_image Planet16 thermograph1)
	(have_image Star17 thermograph1)
	(have_image Star18 thermograph2)
	(have_image Star19 infrared0)
	(have_image Planet20 thermograph2)
	(have_image Planet21 thermograph1)
	(have_image Star22 thermograph2)
))

)
