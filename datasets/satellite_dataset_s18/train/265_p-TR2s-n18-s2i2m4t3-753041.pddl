(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	thermograph1 - mode
	spectrograph3 - mode
	thermograph2 - mode
	infrared0 - mode
	GroundStation1 - direction
	Star0 - direction
	Star2 - direction
	Planet3 - direction
	Phenomenon4 - direction
	Star5 - direction
	Planet6 - direction
	Phenomenon7 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 spectrograph3)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 thermograph1)
	(supports instrument1 infrared0)
	(calibration_target instrument1 GroundStation1)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet6)
	(supports instrument2 spectrograph3)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 Star0)
	(supports instrument3 infrared0)
	(supports instrument3 spectrograph3)
	(calibration_target instrument3 Star2)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star0)
)
(:goal (and
	(pointing satellite0 Phenomenon7)
	(have_image Planet3 thermograph1)
	(have_image Phenomenon4 thermograph1)
	(have_image Star5 thermograph1)
	(have_image Planet6 infrared0)
	(have_image Phenomenon7 thermograph1)
))

)
