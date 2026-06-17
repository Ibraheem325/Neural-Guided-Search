(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph4 - mode
	thermograph2 - mode
	thermograph1 - mode
	image0 - mode
	infrared5 - mode
	infrared3 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	GroundStation7 - direction
	Star8 - direction
	Star9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	GroundStation3 - direction
	Star6 - direction
	Star5 - direction
	Phenomenon12 - direction
	Planet13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 infrared3)
	(supports instrument0 infrared5)
	(supports instrument0 image0)
	(supports instrument0 thermograph1)
	(supports instrument0 thermograph4)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 GroundStation3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon14)
)
(:goal (and
	(pointing satellite0 Planet13)
	(have_image Phenomenon12 image0)
	(have_image Planet13 thermograph2)
	(have_image Planet13 infrared3)
	(have_image Phenomenon14 infrared3)
	(have_image Phenomenon15 thermograph2)
	(have_image Phenomenon15 thermograph1)
))

)
