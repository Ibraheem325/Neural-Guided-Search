(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph3 - mode
	infrared1 - mode
	image2 - mode
	infrared0 - mode
	GroundStation0 - direction
	Planet1 - direction
	Star2 - direction
	Star3 - direction
	Phenomenon4 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 infrared0)
	(supports instrument0 image2)
	(supports instrument0 spectrograph3)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
)
(:goal (and
	(pointing satellite0 Star3)
	(have_image Planet1 spectrograph3)
	(have_image Star2 infrared0)
	(have_image Star3 infrared1)
	(have_image Phenomenon4 spectrograph3)
))

)
