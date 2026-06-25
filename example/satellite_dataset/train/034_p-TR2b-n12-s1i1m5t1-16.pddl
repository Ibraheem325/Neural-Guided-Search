(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph3 - mode
	image2 - mode
	infrared0 - mode
	infrared1 - mode
	thermograph4 - mode
	Star0 - direction
	Phenomenon1 - direction
	Star2 - direction
	Planet3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 spectrograph3)
	(supports instrument0 image2)
	(supports instrument0 thermograph4)
	(supports instrument0 infrared1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet3)
)
(:goal (and
	(have_image Phenomenon1 infrared0)
	(have_image Star2 infrared1)
	(have_image Planet3 image2)
	(have_image Planet4 image2)
))

)
