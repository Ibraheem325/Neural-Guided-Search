(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	image2 - mode
	image1 - mode
	spectrograph3 - mode
	infrared0 - mode
	GroundStation2 - direction
	Star1 - direction
	GroundStation0 - direction
	Planet3 - direction
	Star4 - direction
	Phenomenon5 - direction
	Star6 - direction
	Planet7 - direction
	Phenomenon8 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 image1)
	(supports instrument0 spectrograph3)
	(supports instrument0 image2)
	(calibration_target instrument0 Star1)
	(supports instrument1 spectrograph3)
	(calibration_target instrument1 GroundStation0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet7)
)
(:goal (and
	(pointing satellite0 Phenomenon8)
	(have_image Planet3 image2)
	(have_image Star4 image1)
	(have_image Phenomenon5 image2)
	(have_image Star6 infrared0)
	(have_image Planet7 image2)
	(have_image Phenomenon8 image1)
))

)
