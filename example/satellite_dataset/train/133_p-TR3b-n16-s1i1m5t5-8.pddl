(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph2 - mode
	image0 - mode
	thermograph4 - mode
	thermograph1 - mode
	infrared3 - mode
	Star0 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	GroundStation1 - direction
	Star5 - direction
	Planet6 - direction
	Star7 - direction
	Phenomenon8 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 image0)
	(supports instrument0 thermograph1)
	(supports instrument0 thermograph4)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
)
(:goal (and
	(pointing satellite0 Star0)
	(have_image Star5 image0)
	(have_image Planet6 thermograph4)
	(have_image Star7 thermograph2)
	(have_image Phenomenon8 thermograph1)
))

)
