(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	infrared1 - mode
	infrared3 - mode
	image0 - mode
	image6 - mode
	infrared4 - mode
	infrared5 - mode
	thermograph2 - mode
	Star0 - direction
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	Star9 - direction
	GroundStation11 - direction
	Star10 - direction
	GroundStation12 - direction
	Star5 - direction
	Star1 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Star16 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 infrared4)
	(supports instrument0 image6)
	(supports instrument0 infrared3)
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 Star10)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation11)
	(supports instrument1 image0)
	(supports instrument1 infrared5)
	(calibration_target instrument1 Star1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation12)
)
(:goal (and
	(pointing satellite0 Star2)
	(have_image Phenomenon13 infrared3)
	(have_image Phenomenon14 infrared1)
	(have_image Phenomenon14 image0)
	(have_image Phenomenon15 infrared1)
	(have_image Phenomenon15 infrared4)
	(have_image Star16 image0)
	(have_image Star16 infrared5)
))

)
