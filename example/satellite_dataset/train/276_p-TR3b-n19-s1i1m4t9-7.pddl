(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph2 - mode
	thermograph1 - mode
	infrared3 - mode
	image0 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star3 - direction
	Planet9 - direction
	Phenomenon10 - direction
	Phenomenon11 - direction
	Phenomenon12 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 image0)
	(supports instrument0 infrared3)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon11)
)
(:goal (and
	(have_image Planet9 thermograph1)
	(have_image Phenomenon10 thermograph1)
	(have_image Phenomenon11 image0)
	(have_image Phenomenon12 spectrograph2)
))

)
