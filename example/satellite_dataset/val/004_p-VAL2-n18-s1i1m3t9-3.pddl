(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	image2 - mode
	infrared1 - mode
	Star0 - direction
	Star3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation1 - direction
	Star2 - direction
	Phenomenon9 - direction
	Planet10 - direction
	Phenomenon11 - direction
	Planet12 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 image2)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
)
(:goal (and
	(pointing satellite0 GroundStation8)
	(have_image Phenomenon9 infrared1)
	(have_image Planet10 image2)
	(have_image Phenomenon11 spectrograph0)
	(have_image Planet12 spectrograph0)
))

)
