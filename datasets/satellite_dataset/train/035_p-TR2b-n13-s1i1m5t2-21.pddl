(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared1 - mode
	infrared4 - mode
	image2 - mode
	spectrograph0 - mode
	spectrograph3 - mode
	GroundStation1 - direction
	GroundStation0 - direction
	Star2 - direction
	Phenomenon3 - direction
	Planet4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 infrared1)
	(supports instrument0 spectrograph3)
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared4)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon3)
)
(:goal (and
	(pointing satellite0 GroundStation1)
	(have_image Star2 spectrograph0)
	(have_image Phenomenon3 spectrograph0)
	(have_image Planet4 image2)
	(have_image Planet5 infrared4)
))

)
