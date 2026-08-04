(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	image2 - mode
	image0 - mode
	infrared3 - mode
	image1 - mode
	Star2 - direction
	Star3 - direction
	Star4 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star0 - direction
	GroundStation5 - direction
	GroundStation1 - direction
	Star6 - direction
	Planet11 - direction
	Planet12 - direction
	Phenomenon13 - direction
	Planet14 - direction
	Planet15 - direction
	Phenomenon16 - direction
	Planet17 - direction
	Star18 - direction
	Planet19 - direction
	Planet20 - direction
	Star21 - direction
	Star22 - direction
	Planet23 - direction
	Star24 - direction
	Star25 - direction
	Star26 - direction
	Phenomenon27 - direction
)
(:init
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 GroundStation5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
	(supports instrument1 infrared3)
	(supports instrument1 image0)
	(supports instrument1 image2)
	(supports instrument1 image1)
	(calibration_target instrument1 Star6)
	(calibration_target instrument1 GroundStation1)
	(calibration_target instrument1 GroundStation5)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation5)
)
(:goal (and
	(pointing satellite0 Star22)
	(have_image Planet11 image2)
	(have_image Planet12 image1)
	(have_image Phenomenon13 image2)
	(have_image Planet14 image0)
	(have_image Planet15 image0)
	(have_image Phenomenon16 infrared3)
	(have_image Planet17 image1)
	(have_image Star18 image2)
	(have_image Planet19 image2)
	(have_image Planet20 image0)
	(have_image Star21 image2)
	(have_image Star22 infrared3)
	(have_image Planet23 image0)
	(have_image Star24 image1)
	(have_image Star25 image2)
	(have_image Star26 infrared3)
	(have_image Phenomenon27 image1)
))

)
