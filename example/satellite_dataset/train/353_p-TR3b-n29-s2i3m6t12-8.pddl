(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	thermograph4 - mode
	infrared3 - mode
	infrared5 - mode
	thermograph1 - mode
	thermograph2 - mode
	image0 - mode
	GroundStation7 - direction
	GroundStation3 - direction
	Star5 - direction
	GroundStation2 - direction
	GroundStation0 - direction
	GroundStation11 - direction
	Star9 - direction
	GroundStation10 - direction
	Star8 - direction
	GroundStation1 - direction
	Star6 - direction
	GroundStation4 - direction
	Phenomenon12 - direction
	Planet13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 GroundStation3)
	(supports instrument1 infrared5)
	(supports instrument1 thermograph1)
	(supports instrument1 infrared3)
	(calibration_target instrument1 Star8)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 GroundStation11)
	(supports instrument2 image0)
	(supports instrument2 thermograph1)
	(supports instrument2 infrared3)
	(calibration_target instrument2 Star6)
	(calibration_target instrument2 Star9)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 GroundStation0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon14)
	(supports instrument3 thermograph4)
	(calibration_target instrument3 Star9)
	(calibration_target instrument3 GroundStation0)
	(supports instrument4 thermograph1)
	(supports instrument4 image0)
	(calibration_target instrument4 GroundStation10)
	(calibration_target instrument4 Star9)
	(calibration_target instrument4 GroundStation11)
	(calibration_target instrument4 Star6)
	(supports instrument5 infrared5)
	(calibration_target instrument5 GroundStation4)
	(calibration_target instrument5 Star6)
	(calibration_target instrument5 GroundStation1)
	(calibration_target instrument5 Star8)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation10)
)
(:goal (and
	(pointing satellite0 Planet13)
	(have_image Phenomenon12 image0)
	(have_image Planet13 thermograph2)
	(have_image Planet13 infrared3)
	(have_image Phenomenon14 infrared3)
	(have_image Phenomenon15 thermograph2)
	(have_image Phenomenon15 thermograph1)
))

)
