(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared3 - mode
	image0 - mode
	thermograph2 - mode
	thermograph4 - mode
	thermograph1 - mode
	Star0 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation1 - direction
	Planet4 - direction
	Phenomenon5 - direction
	Star6 - direction
	Planet7 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 thermograph1)
	(supports instrument0 thermograph4)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared3)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
)
(:goal (and
	(have_image Planet4 thermograph2)
	(have_image Phenomenon5 infrared3)
	(have_image Star6 thermograph4)
	(have_image Planet7 thermograph4)
))

)
