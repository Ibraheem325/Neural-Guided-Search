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
	satellite4 - satellite
	instrument4 - instrument
	image2 - mode
	thermograph1 - mode
	thermograph3 - mode
	infrared0 - mode
	GroundStation3 - direction
	Star1 - direction
	GroundStation0 - direction
	GroundStation2 - direction
	Planet4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet4)
	(supports instrument1 infrared0)
	(calibration_target instrument1 GroundStation0)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation2)
	(supports instrument2 image2)
	(supports instrument2 infrared0)
	(supports instrument2 thermograph3)
	(calibration_target instrument2 Star1)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation0)
	(supports instrument3 image2)
	(supports instrument3 thermograph3)
	(supports instrument3 thermograph1)
	(calibration_target instrument3 GroundStation0)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet4)
	(supports instrument4 image2)
	(supports instrument4 thermograph1)
	(supports instrument4 thermograph3)
	(calibration_target instrument4 GroundStation2)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation3)
)
(:goal (and
	(pointing satellite1 Planet4)
	(pointing satellite3 GroundStation2)
	(pointing satellite4 Planet5)
	(have_image Planet4 image2)
	(have_image Planet5 infrared0)
))

)
