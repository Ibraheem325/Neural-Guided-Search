(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared3 - mode
	infrared1 - mode
	image0 - mode
	thermograph2 - mode
	Star0 - direction
	Phenomenon1 - direction
	Phenomenon2 - direction
	Phenomenon3 - direction
	Star4 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared1)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon3)
)
(:goal (and
	(have_image Phenomenon1 infrared3)
	(have_image Phenomenon2 infrared1)
	(have_image Phenomenon3 thermograph2)
	(have_image Star4 image0)
))

)
