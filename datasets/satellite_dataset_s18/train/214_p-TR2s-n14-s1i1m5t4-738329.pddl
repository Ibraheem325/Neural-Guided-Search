(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph4 - mode
	spectrograph3 - mode
	image1 - mode
	infrared0 - mode
	spectrograph2 - mode
	Star0 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation1 - direction
	Phenomenon4 - direction
	Star5 - direction
	Phenomenon6 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph3)
	(supports instrument0 infrared0)
	(supports instrument0 spectrograph4)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
)
(:goal (and
	(have_image Phenomenon4 spectrograph4)
	(have_image Star5 infrared0)
	(have_image Phenomenon6 spectrograph3)
))

)
