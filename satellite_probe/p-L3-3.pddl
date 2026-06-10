(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	image2 - mode
	spectrograph0 - mode
	image3 - mode
	infrared1 - mode
	Star0 - direction
	Star3 - direction
	Star7 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	Star14 - direction
	GroundStation15 - direction
	GroundStation16 - direction
	Star17 - direction
	Star18 - direction
	GroundStation19 - direction
	Star6 - direction
	Star5 - direction
	Star2 - direction
	GroundStation1 - direction
	Star4 - direction
	Star13 - direction
	Star20 - direction
	Phenomenon21 - direction
	Planet22 - direction
	Star23 - direction
	Star24 - direction
	Planet25 - direction
	Phenomenon26 - direction
	Phenomenon27 - direction
	Star28 - direction
	Phenomenon29 - direction
	Star30 - direction
	Planet31 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 infrared1)
	(supports instrument0 image3)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 Star6)
	(supports instrument1 image3)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 GroundStation1)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star20)
	(supports instrument2 infrared1)
	(supports instrument2 image3)
	(supports instrument2 image2)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 Star13)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation1)
)
(:goal (and
	(pointing satellite0 Phenomenon29)
	(have_image Star20 image2)
	(have_image Phenomenon21 infrared1)
	(have_image Planet22 infrared1)
	(have_image Star23 spectrograph0)
	(have_image Star24 infrared1)
	(have_image Planet25 image3)
	(have_image Phenomenon26 image3)
	(have_image Phenomenon27 image3)
	(have_image Star28 infrared1)
	(have_image Phenomenon29 image2)
	(have_image Star30 image3)
	(have_image Planet31 image3)
))

)
