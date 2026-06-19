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
	satellite2 - satellite
	instrument6 - instrument
	instrument7 - instrument
	instrument8 - instrument
	infrared5 - mode
	thermograph1 - mode
	thermograph4 - mode
	infrared3 - mode
	thermograph2 - mode
	thermograph6 - mode
	image0 - mode
	GroundStation3 - direction
	Star12 - direction
	Star5 - direction
	Star8 - direction
	GroundStation6 - direction
	GroundStation0 - direction
	GroundStation9 - direction
	GroundStation2 - direction
	Star11 - direction
	Star13 - direction
	GroundStation10 - direction
	GroundStation1 - direction
	GroundStation4 - direction
	Star7 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Planet16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 thermograph4)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation4)
	(supports instrument1 thermograph4)
	(supports instrument1 infrared3)
	(calibration_target instrument1 GroundStation4)
	(calibration_target instrument1 Star8)
	(supports instrument2 thermograph2)
	(supports instrument2 infrared3)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 GroundStation0)
	(calibration_target instrument2 GroundStation6)
	(calibration_target instrument2 GroundStation9)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
	(supports instrument3 infrared3)
	(supports instrument3 infrared5)
	(supports instrument3 image0)
	(calibration_target instrument3 Star13)
	(calibration_target instrument3 GroundStation9)
	(supports instrument4 infrared3)
	(supports instrument4 thermograph1)
	(calibration_target instrument4 GroundStation2)
	(supports instrument5 image0)
	(supports instrument5 thermograph4)
	(supports instrument5 infrared5)
	(calibration_target instrument5 Star7)
	(calibration_target instrument5 GroundStation10)
	(calibration_target instrument5 Star13)
	(calibration_target instrument5 Star11)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation4)
	(supports instrument6 thermograph4)
	(calibration_target instrument6 GroundStation1)
	(supports instrument7 thermograph6)
	(calibration_target instrument7 GroundStation4)
	(calibration_target instrument7 GroundStation1)
	(calibration_target instrument7 GroundStation10)
	(supports instrument8 infrared3)
	(supports instrument8 infrared5)
	(supports instrument8 thermograph6)
	(calibration_target instrument8 Star7)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star7)
)
(:goal (and
	(pointing satellite1 Phenomenon15)
	(have_image Planet14 image0)
	(have_image Phenomenon15 thermograph4)
	(have_image Planet16 infrared5)
	(have_image Phenomenon17 infrared5)
	(have_image Phenomenon17 thermograph2)
))

)
