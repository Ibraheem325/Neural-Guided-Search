(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph2 - mode
	image0 - mode
	infrared1 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	Star3 - direction
	Star4 - direction
	GroundStation5 - direction
	Star6 - direction
	Phenomenon7 - direction
	Star8 - direction
	Star9 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
)
(:goal (and
	(pointing satellite0 GroundStation5)
	(have_image Star6 thermograph2)
	(have_image Phenomenon7 infrared1)
	(have_image Star8 infrared1)
	(have_image Star9 thermograph2)
))

)
