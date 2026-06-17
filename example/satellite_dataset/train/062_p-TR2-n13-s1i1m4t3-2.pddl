(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared3 - mode
	infrared2 - mode
	thermograph1 - mode
	spectrograph0 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	Star3 - direction
	Planet4 - direction
	Phenomenon5 - direction
	Star6 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared2)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star3)
)
(:goal (and
	(pointing satellite0 Star1)
	(have_image Star3 infrared2)
	(have_image Planet4 spectrograph0)
	(have_image Phenomenon5 spectrograph0)
	(have_image Star6 thermograph1)
))

)
