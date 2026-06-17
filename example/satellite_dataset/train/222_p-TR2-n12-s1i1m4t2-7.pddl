(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph2 - mode
	image0 - mode
	thermograph1 - mode
	infrared3 - mode
	Star0 - direction
	Star1 - direction
	Planet2 - direction
	Star3 - direction
	Planet4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 infrared3)
	(supports instrument0 thermograph1)
	(supports instrument0 image0)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
)
(:goal (and
	(pointing satellite0 Planet4)
	(have_image Planet2 infrared3)
	(have_image Star3 infrared3)
	(have_image Planet4 infrared3)
	(have_image Planet5 image0)
))

)
