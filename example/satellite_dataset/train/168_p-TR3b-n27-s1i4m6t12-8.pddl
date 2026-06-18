(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	thermograph4 - mode
	thermograph2 - mode
	infrared3 - mode
	infrared5 - mode
	thermograph1 - mode
	image0 - mode
	GroundStation1 - direction
	GroundStation4 - direction
	GroundStation7 - direction
	GroundStation10 - direction
	GroundStation3 - direction
	GroundStation11 - direction
	GroundStation0 - direction
	Star6 - direction
	GroundStation2 - direction
	Star9 - direction
	Star5 - direction
	Star8 - direction
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
	(supports instrument1 thermograph4)
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
	(supports instrument3 thermograph2)
	(calibration_target instrument3 Star8)
	(calibration_target instrument3 Star5)
	(calibration_target instrument3 Star9)
	(calibration_target instrument3 GroundStation2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon14)
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
