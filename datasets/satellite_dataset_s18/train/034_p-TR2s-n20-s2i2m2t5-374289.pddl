(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	spectrograph1 - mode
	infrared0 - mode
	GroundStation1 - direction
	Star3 - direction
	GroundStation4 - direction
	Star0 - direction
	Star2 - direction
	Phenomenon5 - direction
	Planet6 - direction
	Star7 - direction
	Planet8 - direction
	Planet9 - direction
	Phenomenon10 - direction
	Star11 - direction
	Phenomenon12 - direction
	Phenomenon13 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
	(supports instrument1 infrared0)
	(supports instrument1 spectrograph1)
	(calibration_target instrument1 Star2)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star2)
)
(:goal (and
	(have_image Phenomenon5 infrared0)
	(have_image Planet6 spectrograph1)
	(have_image Star7 spectrograph1)
	(have_image Planet8 infrared0)
	(have_image Planet9 infrared0)
	(have_image Phenomenon10 infrared0)
	(have_image Star11 spectrograph1)
	(have_image Phenomenon12 spectrograph1)
	(have_image Phenomenon13 spectrograph1)
))

)
