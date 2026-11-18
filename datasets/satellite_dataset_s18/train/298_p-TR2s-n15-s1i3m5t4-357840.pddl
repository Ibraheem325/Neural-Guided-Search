(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	spectrograph0 - mode
	spectrograph2 - mode
	image4 - mode
	image1 - mode
	image3 - mode
	GroundStation1 - direction
	Star3 - direction
	GroundStation0 - direction
	Star2 - direction
	Planet4 - direction
	Planet5 - direction
	Phenomenon6 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 image1)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 image4)
	(supports instrument1 image3)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 Star2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation0)
)
(:goal (and
	(pointing satellite0 Phenomenon6)
	(have_image Planet4 spectrograph0)
	(have_image Planet5 spectrograph2)
	(have_image Phenomenon6 spectrograph0)
))

)
