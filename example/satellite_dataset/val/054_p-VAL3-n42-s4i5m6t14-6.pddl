(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	satellite3 - satellite
	instrument6 - instrument
	instrument7 - instrument
	instrument8 - instrument
	thermograph2 - mode
	infrared4 - mode
	thermograph5 - mode
	thermograph1 - mode
	image3 - mode
	infrared0 - mode
	Star6 - direction
	GroundStation11 - direction
	Star12 - direction
	GroundStation0 - direction
	GroundStation5 - direction
	GroundStation8 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation4 - direction
	Star10 - direction
	GroundStation13 - direction
	GroundStation9 - direction
	GroundStation3 - direction
	GroundStation7 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Planet16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 image3)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation7)
	(supports instrument1 image3)
	(calibration_target instrument1 Star10)
	(calibration_target instrument1 GroundStation13)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 Star2)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation5)
	(supports instrument2 infrared4)
	(supports instrument2 thermograph1)
	(supports instrument2 thermograph5)
	(calibration_target instrument2 GroundStation13)
	(supports instrument3 image3)
	(calibration_target instrument3 GroundStation5)
	(calibration_target instrument3 GroundStation0)
	(calibration_target instrument3 Star2)
	(supports instrument4 infrared4)
	(supports instrument4 thermograph2)
	(calibration_target instrument4 GroundStation3)
	(calibration_target instrument4 GroundStation1)
	(supports instrument5 thermograph5)
	(supports instrument5 thermograph1)
	(calibration_target instrument5 GroundStation1)
	(calibration_target instrument5 GroundStation8)
	(on_board instrument2 satellite2)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation11)
	(supports instrument6 thermograph1)
	(supports instrument6 image3)
	(calibration_target instrument6 Star10)
	(calibration_target instrument6 GroundStation4)
	(calibration_target instrument6 Star2)
	(supports instrument7 image3)
	(supports instrument7 infrared4)
	(supports instrument7 infrared0)
	(calibration_target instrument7 GroundStation9)
	(calibration_target instrument7 GroundStation13)
	(supports instrument8 thermograph2)
	(supports instrument8 thermograph5)
	(supports instrument8 image3)
	(calibration_target instrument8 GroundStation7)
	(calibration_target instrument8 GroundStation3)
	(on_board instrument6 satellite3)
	(on_board instrument7 satellite3)
	(on_board instrument8 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star6)
)
(:goal (and
	(pointing satellite3 Planet16)
	(have_image Planet14 infrared0)
	(have_image Planet14 image3)
	(have_image Phenomenon15 image3)
	(have_image Planet16 image3)
	(have_image Phenomenon17 infrared0)
))

)
