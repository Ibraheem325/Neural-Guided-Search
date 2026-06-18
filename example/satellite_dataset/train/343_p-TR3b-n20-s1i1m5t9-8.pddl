(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph1 - mode
	infrared3 - mode
	thermograph4 - mode
	thermograph2 - mode
	image0 - mode
	GroundStation1 - direction
	Star2 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	Star8 - direction
	GroundStation3 - direction
	Star0 - direction
	Star9 - direction
	Planet10 - direction
	Star11 - direction
	Phenomenon12 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 thermograph1)
	(supports instrument0 thermograph4)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 GroundStation3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
)
(:goal (and
	(have_image Star9 infrared3)
	(have_image Planet10 image0)
	(have_image Star11 thermograph4)
	(have_image Phenomenon12 thermograph2)
))

)
