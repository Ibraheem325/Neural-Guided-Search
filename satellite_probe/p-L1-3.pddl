(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	image2 - mode
	infrared1 - mode
	spectrograph0 - mode
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star6 - direction
	Star9 - direction
	GroundStation1 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star5 - direction
	Star0 - direction
	Star10 - direction
	Phenomenon11 - direction
	Star12 - direction
	Planet13 - direction
	Phenomenon14 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 image2)
	(supports instrument1 infrared1)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 GroundStation8)
	(calibration_target instrument1 Star5)
	(supports instrument2 infrared1)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 Star0)
	(calibration_target instrument2 Star5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet13)
)
(:goal (and
	(have_image Star10 image2)
	(have_image Phenomenon11 infrared1)
	(have_image Star12 spectrograph0)
	(have_image Planet13 spectrograph0)
	(have_image Phenomenon14 spectrograph0)
))

)
