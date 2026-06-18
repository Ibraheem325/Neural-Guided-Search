(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	thermograph2 - mode
	thermograph4 - mode
	thermograph1 - mode
	infrared3 - mode
	Star0 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	Star8 - direction
	Star10 - direction
	GroundStation11 - direction
	Star12 - direction
	Star13 - direction
	Star9 - direction
	Star14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 infrared3)
	(supports instrument0 thermograph1)
	(supports instrument0 thermograph2)
	(supports instrument0 image0)
	(calibration_target instrument0 Star9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star12)
)
(:goal (and
	(have_image Star14 thermograph4)
	(have_image Phenomenon15 infrared3)
	(have_image Phenomenon16 thermograph1)
	(have_image Planet17 thermograph4)
))

)
