(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	image1 - mode
	image2 - mode
	infrared3 - mode
	spectrograph0 - mode
	GroundStation1 - direction
	Star3 - direction
	Star4 - direction
	Star6 - direction
	Star7 - direction
	GroundStation5 - direction
	Star2 - direction
	GroundStation0 - direction
	Planet8 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 image2)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 Star7)
	(supports instrument1 infrared3)
	(supports instrument1 image1)
	(supports instrument1 image2)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 GroundStation0)
	(calibration_target instrument1 Star2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation5)
)
(:goal (and
	(have_image Planet8 infrared3)
))

)
