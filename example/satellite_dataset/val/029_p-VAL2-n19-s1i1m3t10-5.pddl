(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph2 - mode
	infrared1 - mode
	image0 - mode
	Star0 - direction
	Star2 - direction
	Star3 - direction
	Star4 - direction
	Star6 - direction
	GroundStation7 - direction
	Star9 - direction
	Star1 - direction
	GroundStation5 - direction
	GroundStation8 - direction
	Star10 - direction
	Phenomenon11 - direction
	Planet12 - direction
	Star13 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 image0)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet12)
)
(:goal (and
	(have_image Star10 image0)
	(have_image Phenomenon11 infrared1)
	(have_image Planet12 thermograph2)
	(have_image Star13 infrared1)
))

)
