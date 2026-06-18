(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	instrument4 - instrument
	image0 - mode
	thermograph1 - mode
	infrared3 - mode
	thermograph4 - mode
	thermograph2 - mode
	Star0 - direction
	Star5 - direction
	GroundStation7 - direction
	Star10 - direction
	Star9 - direction
	GroundStation4 - direction
	Star2 - direction
	GroundStation11 - direction
	GroundStation3 - direction
	GroundStation6 - direction
	Star8 - direction
	GroundStation1 - direction
	Star12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 infrared3)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 Star9)
	(supports instrument1 thermograph1)
	(supports instrument1 thermograph2)
	(supports instrument1 infrared3)
	(calibration_target instrument1 Star2)
	(calibration_target instrument1 GroundStation4)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
	(supports instrument2 image0)
	(supports instrument2 infrared3)
	(supports instrument2 thermograph1)
	(calibration_target instrument2 GroundStation11)
	(calibration_target instrument2 Star8)
	(supports instrument3 thermograph2)
	(supports instrument3 thermograph4)
	(supports instrument3 infrared3)
	(calibration_target instrument3 Star8)
	(calibration_target instrument3 GroundStation6)
	(calibration_target instrument3 GroundStation3)
	(supports instrument4 thermograph2)
	(supports instrument4 thermograph4)
	(calibration_target instrument4 GroundStation1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation7)
)
(:goal (and
	(have_image Star12 thermograph2)
	(have_image Phenomenon13 thermograph2)
	(have_image Phenomenon14 image0)
	(have_image Planet15 infrared3)
))

)
