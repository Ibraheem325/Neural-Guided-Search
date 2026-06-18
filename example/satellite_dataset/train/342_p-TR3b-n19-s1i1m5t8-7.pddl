(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared4 - mode
	thermograph1 - mode
	infrared3 - mode
	image0 - mode
	spectrograph2 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	Star3 - direction
	Star4 - direction
	GroundStation5 - direction
	Star7 - direction
	GroundStation6 - direction
	Phenomenon8 - direction
	Phenomenon9 - direction
	Phenomenon10 - direction
	Phenomenon11 - direction
)
(:init
	(supports instrument0 infrared4)
	(supports instrument0 spectrograph2)
	(supports instrument0 infrared3)
	(supports instrument0 image0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon8)
)
(:goal (and
	(pointing satellite0 Phenomenon11)
	(have_image Phenomenon8 image0)
	(have_image Phenomenon9 image0)
	(have_image Phenomenon10 thermograph1)
	(have_image Phenomenon11 infrared4)
))

)
