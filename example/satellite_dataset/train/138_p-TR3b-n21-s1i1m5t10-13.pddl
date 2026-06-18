(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph4 - mode
	spectrograph0 - mode
	thermograph2 - mode
	image1 - mode
	infrared3 - mode
	Star0 - direction
	GroundStation1 - direction
	Star2 - direction
	Star3 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star9 - direction
	Star4 - direction
	Star5 - direction
	Star6 - direction
	Planet10 - direction
	Star11 - direction
	Phenomenon12 - direction
	Star13 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 spectrograph4)
	(supports instrument0 infrared3)
	(supports instrument0 image1)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon12)
)
(:goal (and
	(have_image Planet10 spectrograph4)
	(have_image Star11 image1)
	(have_image Phenomenon12 infrared3)
	(have_image Star13 spectrograph4)
))

)
