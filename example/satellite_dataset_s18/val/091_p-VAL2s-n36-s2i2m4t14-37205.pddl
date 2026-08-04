(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	image2 - mode
	infrared3 - mode
	infrared0 - mode
	thermograph1 - mode
	GroundStation1 - direction
	GroundStation7 - direction
	GroundStation9 - direction
	GroundStation11 - direction
	GroundStation10 - direction
	GroundStation4 - direction
	Star13 - direction
	Star5 - direction
	Star8 - direction
	GroundStation0 - direction
	Star12 - direction
	Star6 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Star17 - direction
	Phenomenon18 - direction
	Star19 - direction
	Phenomenon20 - direction
	Planet21 - direction
	Star22 - direction
	Phenomenon23 - direction
	Star24 - direction
	Phenomenon25 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 GroundStation4)
	(supports instrument1 infrared3)
	(supports instrument1 image2)
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 Star13)
	(calibration_target instrument1 GroundStation4)
	(calibration_target instrument1 GroundStation3)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star12)
	(supports instrument2 infrared0)
	(supports instrument2 image2)
	(supports instrument2 infrared3)
	(calibration_target instrument2 GroundStation0)
	(calibration_target instrument2 Star8)
	(supports instrument3 thermograph1)
	(calibration_target instrument3 GroundStation3)
	(calibration_target instrument3 GroundStation2)
	(calibration_target instrument3 Star6)
	(calibration_target instrument3 Star12)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation11)
)
(:goal (and
	(pointing satellite1 Phenomenon15)
	(have_image Phenomenon14 infrared0)
	(have_image Phenomenon15 thermograph1)
	(have_image Star16 infrared0)
	(have_image Star17 image2)
	(have_image Phenomenon18 infrared0)
	(have_image Star19 infrared0)
	(have_image Phenomenon20 infrared3)
	(have_image Planet21 thermograph1)
	(have_image Star22 infrared3)
	(have_image Phenomenon23 infrared0)
	(have_image Star24 infrared3)
	(have_image Phenomenon25 infrared3)
))

)
