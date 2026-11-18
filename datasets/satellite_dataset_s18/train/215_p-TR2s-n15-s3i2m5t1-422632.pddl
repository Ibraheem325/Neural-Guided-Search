(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	infrared0 - mode
	image3 - mode
	thermograph1 - mode
	infrared2 - mode
	thermograph4 - mode
	GroundStation0 - direction
	Planet1 - direction
	Phenomenon2 - direction
)
(:init
	(supports instrument0 thermograph4)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 image3)
	(supports instrument1 thermograph1)
	(supports instrument1 infrared2)
	(calibration_target instrument1 GroundStation0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
	(supports instrument2 thermograph4)
	(calibration_target instrument2 GroundStation0)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation0)
	(supports instrument3 infrared0)
	(supports instrument3 image3)
	(supports instrument3 thermograph4)
	(calibration_target instrument3 GroundStation0)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet1)
)
(:goal (and
	(pointing satellite0 GroundStation0)
	(have_image Planet1 image3)
	(have_image Phenomenon2 thermograph4)
))

)
