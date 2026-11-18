(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	instrument3 - instrument
	thermograph3 - mode
	spectrograph2 - mode
	thermograph0 - mode
	spectrograph1 - mode
	GroundStation0 - direction
	Planet1 - direction
	Phenomenon2 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
	(supports instrument1 spectrograph2)
	(supports instrument1 spectrograph1)
	(calibration_target instrument1 GroundStation0)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation0)
	(supports instrument2 thermograph0)
	(supports instrument2 thermograph3)
	(supports instrument2 spectrograph2)
	(calibration_target instrument2 GroundStation0)
	(supports instrument3 spectrograph2)
	(supports instrument3 thermograph3)
	(calibration_target instrument3 GroundStation0)
	(on_board instrument2 satellite2)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet1)
)
(:goal (and
	(pointing satellite1 GroundStation0)
	(pointing satellite2 Phenomenon2)
	(have_image Planet1 spectrograph1)
	(have_image Phenomenon2 thermograph0)
))

)
