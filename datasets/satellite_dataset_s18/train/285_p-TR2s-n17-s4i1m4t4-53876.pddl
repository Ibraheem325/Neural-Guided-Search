(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	infrared0 - mode
	infrared3 - mode
	thermograph1 - mode
	thermograph2 - mode
	GroundStation1 - direction
	Star2 - direction
	Star3 - direction
	Star0 - direction
	Phenomenon4 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
	(supports instrument1 infrared0)
	(calibration_target instrument1 Star0)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star2)
	(supports instrument2 infrared0)
	(supports instrument2 infrared3)
	(supports instrument2 thermograph1)
	(calibration_target instrument2 Star3)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon4)
	(supports instrument3 thermograph2)
	(calibration_target instrument3 Star0)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation1)
)
(:goal (and
	(pointing satellite2 Star0)
	(pointing satellite3 Phenomenon4)
	(have_image Phenomenon4 infrared0)
))

)
