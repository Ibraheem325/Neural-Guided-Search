(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	spectrograph3 - mode
	infrared0 - mode
	thermograph4 - mode
	thermograph1 - mode
	Star0 - direction
	Planet1 - direction
	Star2 - direction
	Phenomenon3 - direction
	Phenomenon4 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph3)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared0)
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
)
(:goal (and
	(pointing satellite0 Star2)
	(have_image Planet1 thermograph1)
	(have_image Star2 infrared2)
	(have_image Phenomenon3 spectrograph3)
	(have_image Phenomenon4 infrared0)
))

)
