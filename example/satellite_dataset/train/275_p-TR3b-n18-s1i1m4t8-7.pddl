(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared3 - mode
	image0 - mode
	thermograph1 - mode
	spectrograph2 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	Star4 - direction
	GroundStation5 - direction
	GroundStation7 - direction
	GroundStation6 - direction
	Planet8 - direction
	Planet9 - direction
	Phenomenon10 - direction
	Phenomenon11 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph2)
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 GroundStation7)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation2)
)
(:goal (and
	(pointing satellite0 Star4)
	(have_image Planet8 infrared3)
	(have_image Planet9 spectrograph2)
	(have_image Phenomenon10 image0)
	(have_image Phenomenon11 thermograph1)
))

)
