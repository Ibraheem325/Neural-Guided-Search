(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph4 - mode
	spectrograph2 - mode
	spectrograph1 - mode
	image3 - mode
	infrared0 - mode
	Star0 - direction
	GroundStation1 - direction
	Planet2 - direction
	Star3 - direction
	Phenomenon4 - direction
	Phenomenon5 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 spectrograph4)
	(supports instrument0 spectrograph2)
	(supports instrument0 image3)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star3)
)
(:goal (and
	(pointing satellite0 Star3)
	(have_image Planet2 infrared0)
	(have_image Star3 spectrograph4)
	(have_image Phenomenon4 infrared0)
	(have_image Phenomenon5 spectrograph2)
))

)
