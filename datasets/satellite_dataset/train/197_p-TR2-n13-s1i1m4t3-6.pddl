(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph1 - mode
	infrared0 - mode
	image3 - mode
	thermograph2 - mode
	Star0 - direction
	GroundStation2 - direction
	Star1 - direction
	Phenomenon3 - direction
	Phenomenon4 - direction
	Star5 - direction
	Planet6 - direction
)
(:init
	(supports instrument0 image3)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
)
(:goal (and
	(pointing satellite0 Star1)
	(have_image Phenomenon3 image3)
	(have_image Phenomenon4 infrared0)
	(have_image Star5 thermograph1)
	(have_image Planet6 image3)
))

)
