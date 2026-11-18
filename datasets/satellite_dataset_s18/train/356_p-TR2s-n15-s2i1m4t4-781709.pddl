(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	thermograph3 - mode
	thermograph1 - mode
	infrared2 - mode
	infrared0 - mode
	GroundStation1 - direction
	Star2 - direction
	Star0 - direction
	GroundStation3 - direction
	Phenomenon4 - direction
	Planet5 - direction
	Planet6 - direction
)
(:init
	(supports instrument0 thermograph3)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet6)
	(supports instrument1 infrared2)
	(calibration_target instrument1 GroundStation3)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation3)
)
(:goal (and
	(pointing satellite1 Planet6)
	(have_image Phenomenon4 thermograph1)
	(have_image Planet5 thermograph1)
	(have_image Planet6 infrared0)
))

)
