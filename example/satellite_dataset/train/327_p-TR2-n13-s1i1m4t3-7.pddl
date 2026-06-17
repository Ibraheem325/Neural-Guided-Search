(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph1 - mode
	image0 - mode
	spectrograph2 - mode
	infrared3 - mode
	Star1 - direction
	GroundStation2 - direction
	Star0 - direction
	Star3 - direction
	Planet4 - direction
	Star5 - direction
	Phenomenon6 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 infrared3)
	(supports instrument0 thermograph1)
	(supports instrument0 image0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(have_image Star3 image0)
	(have_image Planet4 spectrograph2)
	(have_image Star5 spectrograph2)
	(have_image Phenomenon6 infrared3)
))

)
