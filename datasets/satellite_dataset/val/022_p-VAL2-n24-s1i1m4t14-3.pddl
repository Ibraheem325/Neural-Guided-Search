(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared1 - mode
	spectrograph0 - mode
	image3 - mode
	image2 - mode
	Star2 - direction
	Star3 - direction
	Star4 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation12 - direction
	Star13 - direction
	GroundStation1 - direction
	Star0 - direction
	Star5 - direction
	GroundStation11 - direction
	Star14 - direction
	Star15 - direction
	Planet16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 image2)
	(supports instrument0 image3)
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation11)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
)
(:goal (and
	(have_image Star14 infrared1)
	(have_image Star15 image3)
	(have_image Planet16 infrared1)
	(have_image Planet17 infrared1)
))

)
