(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	image1 - mode
	infrared3 - mode
	thermograph2 - mode
	GroundStation1 - direction
	Star2 - direction
	Star3 - direction
	GroundStation0 - direction
	Phenomenon4 - direction
	Planet5 - direction
	Planet6 - direction
	Phenomenon7 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared3)
	(supports instrument0 image1)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
)
(:goal (and
	(pointing satellite0 Phenomenon4)
	(have_image Phenomenon4 infrared3)
	(have_image Planet5 spectrograph0)
	(have_image Planet6 image1)
	(have_image Phenomenon7 spectrograph0)
))

)
