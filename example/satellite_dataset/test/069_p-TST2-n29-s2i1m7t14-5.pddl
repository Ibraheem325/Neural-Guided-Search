(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	infrared5 - mode
	infrared3 - mode
	image0 - mode
	infrared4 - mode
	thermograph2 - mode
	infrared1 - mode
	image6 - mode
	Star2 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	Star9 - direction
	Star10 - direction
	GroundStation12 - direction
	Star3 - direction
	Star13 - direction
	Star0 - direction
	GroundStation11 - direction
	Star1 - direction
	Planet14 - direction
	Planet15 - direction
	Phenomenon16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared4)
	(supports instrument0 image6)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
	(supports instrument1 infrared1)
	(supports instrument1 image0)
	(supports instrument1 infrared5)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 GroundStation11)
	(calibration_target instrument1 Star0)
	(calibration_target instrument1 Star13)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet15)
)
(:goal (and
	(pointing satellite1 GroundStation4)
	(have_image Planet14 infrared1)
	(have_image Planet14 infrared3)
	(have_image Planet15 infrared4)
	(have_image Planet15 infrared1)
	(have_image Phenomenon16 thermograph2)
	(have_image Phenomenon16 image6)
	(have_image Phenomenon17 image0)
	(have_image Phenomenon17 infrared5)
))

)
