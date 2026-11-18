(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph2 - mode
	thermograph1 - mode
	image0 - mode
	infrared3 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Star4 - direction
	GroundStation5 - direction
	Star6 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation11 - direction
	Star7 - direction
	GroundStation10 - direction
	Planet12 - direction
	Planet13 - direction
	Star14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 image0)
	(supports instrument0 infrared3)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 Star7)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation11)
)
(:goal (and
	(have_image Planet12 thermograph2)
	(have_image Planet13 thermograph1)
	(have_image Star14 image0)
	(have_image Planet15 image0)
))

)
