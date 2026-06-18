(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared1 - mode
	infrared3 - mode
	infrared4 - mode
	image0 - mode
	thermograph2 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	Star8 - direction
	Star9 - direction
	Star10 - direction
	GroundStation11 - direction
	Star12 - direction
	Star13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 infrared4)
	(supports instrument0 infrared1)
	(supports instrument0 image0)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star13)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon15)
)
(:goal (and
	(have_image Phenomenon14 infrared4)
	(have_image Phenomenon15 image0)
	(have_image Phenomenon16 infrared4)
	(have_image Planet17 infrared1)
))

)
