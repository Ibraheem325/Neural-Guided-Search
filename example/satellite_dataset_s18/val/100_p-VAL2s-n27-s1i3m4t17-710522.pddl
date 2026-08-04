(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	image3 - mode
	thermograph2 - mode
	image1 - mode
	infrared0 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star7 - direction
	Star9 - direction
	GroundStation14 - direction
	GroundStation15 - direction
	GroundStation16 - direction
	GroundStation3 - direction
	GroundStation12 - direction
	GroundStation4 - direction
	Star8 - direction
	Star10 - direction
	Star11 - direction
	GroundStation5 - direction
	Star13 - direction
	Star6 - direction
	Planet17 - direction
	Phenomenon18 - direction
	Star19 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 image1)
	(calibration_target instrument0 Star10)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 GroundStation3)
	(supports instrument1 infrared0)
	(supports instrument1 thermograph2)
	(supports instrument1 image3)
	(calibration_target instrument1 Star6)
	(calibration_target instrument1 Star13)
	(calibration_target instrument1 GroundStation5)
	(calibration_target instrument1 Star11)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation2)
)
(:goal (and
	(pointing satellite0 Star1)
	(have_image Planet17 infrared0)
	(have_image Phenomenon18 image1)
	(have_image Star19 infrared0)
))

)
