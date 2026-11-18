(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	infrared1 - mode
	image2 - mode
	Star0 - direction
	Star2 - direction
	Star3 - direction
	Star5 - direction
	Star6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star10 - direction
	GroundStation1 - direction
	GroundStation4 - direction
	Star9 - direction
	Star11 - direction
	Phenomenon12 - direction
	Phenomenon13 - direction
	Planet14 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared1)
	(supports instrument0 image2)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star10)
)
(:goal (and
	(have_image Star11 infrared1)
	(have_image Phenomenon12 infrared1)
	(have_image Phenomenon13 spectrograph0)
	(have_image Planet14 infrared1)
))

)
