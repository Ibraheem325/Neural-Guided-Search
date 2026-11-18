(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	infrared1 - mode
	image2 - mode
	Star0 - direction
	GroundStation1 - direction
	Star3 - direction
	Star5 - direction
	Star6 - direction
	Star2 - direction
	GroundStation4 - direction
	Phenomenon7 - direction
	Phenomenon8 - direction
	Planet9 - direction
	Planet10 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 image2)
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon8)
)
(:goal (and
	(have_image Phenomenon7 spectrograph0)
	(have_image Phenomenon8 infrared1)
	(have_image Planet9 infrared1)
	(have_image Planet10 image2)
))

)
