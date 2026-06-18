(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared3 - mode
	thermograph1 - mode
	image0 - mode
	spectrograph2 - mode
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	Star4 - direction
	Star0 - direction
	Planet5 - direction
	Phenomenon6 - direction
	Planet7 - direction
	Planet8 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 image0)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet8)
)
(:goal (and
	(have_image Planet5 spectrograph2)
	(have_image Phenomenon6 image0)
	(have_image Planet7 image0)
	(have_image Planet8 spectrograph2)
))

)
