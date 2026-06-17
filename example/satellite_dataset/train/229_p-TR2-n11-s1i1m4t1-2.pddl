(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared3 - mode
	spectrograph0 - mode
	infrared2 - mode
	thermograph1 - mode
	Star0 - direction
	Star1 - direction
	Planet2 - direction
	Planet3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet4)
)
(:goal (and
	(have_image Star1 infrared2)
	(have_image Planet2 infrared3)
	(have_image Planet3 infrared2)
	(have_image Planet4 infrared2)
))

)
