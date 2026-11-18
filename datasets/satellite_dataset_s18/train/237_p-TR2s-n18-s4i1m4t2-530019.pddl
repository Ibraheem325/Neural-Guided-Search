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
	thermograph3 - mode
	thermograph1 - mode
	infrared0 - mode
	infrared2 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	Phenomenon2 - direction
	Phenomenon3 - direction
	Star4 - direction
	Phenomenon5 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon5)
	(supports instrument1 thermograph3)
	(supports instrument1 infrared2)
	(calibration_target instrument1 GroundStation1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon2)
	(supports instrument2 thermograph1)
	(supports instrument2 infrared0)
	(calibration_target instrument2 GroundStation0)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation1)
	(supports instrument3 thermograph1)
	(supports instrument3 thermograph3)
	(supports instrument3 infrared2)
	(calibration_target instrument3 GroundStation1)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Phenomenon2)
)
(:goal (and
	(pointing satellite2 Phenomenon5)
	(have_image Phenomenon2 infrared2)
	(have_image Phenomenon3 thermograph1)
	(have_image Star4 thermograph3)
	(have_image Phenomenon5 infrared0)
))

)
