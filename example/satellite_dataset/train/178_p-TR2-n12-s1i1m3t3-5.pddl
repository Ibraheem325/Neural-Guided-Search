(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	infrared1 - mode
	thermograph2 - mode
	Star0 - direction
	Star2 - direction
	Star1 - direction
	Phenomenon3 - direction
	Star4 - direction
	Star5 - direction
	Planet6 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
)
(:goal (and
	(pointing satellite0 Star2)
	(have_image Phenomenon3 image0)
	(have_image Star4 image0)
	(have_image Star5 thermograph2)
	(have_image Planet6 image0)
))

)
