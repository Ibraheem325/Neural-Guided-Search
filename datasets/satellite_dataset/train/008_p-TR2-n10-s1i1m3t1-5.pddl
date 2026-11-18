(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	infrared1 - mode
	thermograph2 - mode
	Star0 - direction
	Star1 - direction
	Phenomenon2 - direction
	Phenomenon3 - direction
	Star4 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 thermograph2)
	(supports instrument0 image0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(pointing satellite0 Phenomenon2)
	(have_image Star1 infrared1)
	(have_image Phenomenon2 thermograph2)
	(have_image Phenomenon3 infrared1)
	(have_image Star4 infrared1)
))

)
