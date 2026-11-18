(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	infrared1 - mode
	thermograph3 - mode
	thermograph0 - mode
	image2 - mode
	GroundStation1 - direction
	GroundStation4 - direction
	Star0 - direction
	Star2 - direction
	Star3 - direction
	Star5 - direction
	Phenomenon6 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 image2)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
	(supports instrument1 infrared1)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 Star2)
	(supports instrument2 image2)
	(supports instrument2 thermograph3)
	(supports instrument2 infrared1)
	(calibration_target instrument2 Star3)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star2)
)
(:goal (and
	(pointing satellite1 Star3)
	(have_image Star5 thermograph3)
	(have_image Phenomenon6 infrared1)
))

)
