(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	infrared3 - mode
	thermograph1 - mode
	thermograph4 - mode
	thermograph2 - mode
	Star0 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star5 - direction
	GroundStation6 - direction
	Star8 - direction
	Star9 - direction
	Star10 - direction
	GroundStation7 - direction
	GroundStation4 - direction
	Planet11 - direction
	Star12 - direction
	Star13 - direction
	Star14 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 thermograph2)
	(supports instrument0 thermograph4)
	(supports instrument0 infrared3)
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 GroundStation7)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
)
(:goal (and
	(pointing satellite0 GroundStation6)
	(have_image Planet11 image0)
	(have_image Star12 thermograph1)
	(have_image Star13 image0)
	(have_image Star14 image0)
))

)
