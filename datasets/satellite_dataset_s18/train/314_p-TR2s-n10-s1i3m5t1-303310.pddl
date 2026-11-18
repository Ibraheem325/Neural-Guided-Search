(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	thermograph3 - mode
	thermograph1 - mode
	infrared0 - mode
	spectrograph2 - mode
	thermograph4 - mode
	Star0 - direction
	Star1 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star0)
	(supports instrument1 thermograph4)
	(supports instrument1 infrared0)
	(supports instrument1 thermograph3)
	(calibration_target instrument1 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(have_image Star1 thermograph3)
))

)
