(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph4 - mode
	image0 - mode
	thermograph2 - mode
	thermograph1 - mode
	infrared3 - mode
	infrared5 - mode
	GroundStation0 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation1 - direction
	Star6 - direction
	Phenomenon7 - direction
	Star8 - direction
	Phenomenon9 - direction
	Star10 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 image0)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared5)
	(supports instrument0 infrared3)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star10)
)
(:goal (and
	(have_image Phenomenon7 thermograph4)
	(have_image Star8 thermograph1)
	(have_image Phenomenon9 thermograph2)
	(have_image Star10 thermograph4)
	(have_image Star10 infrared3)
))

)
