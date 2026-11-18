(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	thermograph2 - mode
	thermograph1 - mode
	infrared3 - mode
	spectrograph0 - mode
	GroundStation2 - direction
	GroundStation0 - direction
	GroundStation1 - direction
	Phenomenon3 - direction
	Planet4 - direction
	Star5 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph0)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon3)
	(supports instrument1 spectrograph0)
	(supports instrument1 thermograph2)
	(supports instrument1 thermograph1)
	(calibration_target instrument1 GroundStation1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation0)
)
(:goal (and
	(have_image Phenomenon3 thermograph1)
	(have_image Planet4 thermograph1)
	(have_image Star5 infrared3)
))

)
