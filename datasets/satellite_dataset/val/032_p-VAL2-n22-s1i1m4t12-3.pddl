(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared1 - mode
	image2 - mode
	spectrograph0 - mode
	image3 - mode
	Star0 - direction
	Star2 - direction
	Star3 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation11 - direction
	GroundStation1 - direction
	Star4 - direction
	GroundStation10 - direction
	Planet12 - direction
	Star13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 image3)
	(supports instrument0 spectrograph0)
	(supports instrument0 image2)
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon14)
)
(:goal (and
	(have_image Planet12 spectrograph0)
	(have_image Star13 infrared1)
	(have_image Phenomenon14 spectrograph0)
	(have_image Phenomenon15 image3)
))

)
