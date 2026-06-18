(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared3 - mode
	spectrograph0 - mode
	image1 - mode
	thermograph2 - mode
	GroundStation1 - direction
	Star2 - direction
	GroundStation0 - direction
	Star3 - direction
	Star4 - direction
	Star5 - direction
	Planet6 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 thermograph2)
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared3)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
)
(:goal (and
	(pointing satellite0 Planet6)
	(have_image Star3 infrared3)
	(have_image Star4 spectrograph0)
	(have_image Star5 image1)
	(have_image Planet6 infrared3)
))

)
