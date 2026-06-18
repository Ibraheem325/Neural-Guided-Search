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
	instrument6 - instrument
	infrared2 - mode
	image5 - mode
	image3 - mode
	thermograph4 - mode
	infrared0 - mode
	spectrograph1 - mode
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation7 - direction
	Star9 - direction
	GroundStation8 - direction
	GroundStation0 - direction
	GroundStation11 - direction
	GroundStation10 - direction
	GroundStation3 - direction
	Star5 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	Star12 - direction
	Star13 - direction
	Planet14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 image3)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 GroundStation8)
	(supports instrument1 image5)
	(supports instrument1 spectrograph1)
	(supports instrument1 image3)
	(calibration_target instrument1 GroundStation3)
	(supports instrument2 infrared2)
	(supports instrument2 image5)
	(supports instrument2 image3)
	(calibration_target instrument2 GroundStation6)
	(calibration_target instrument2 GroundStation10)
	(calibration_target instrument2 Star5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation8)
	(supports instrument3 image5)
	(supports instrument3 infrared0)
	(supports instrument3 thermograph4)
	(calibration_target instrument3 GroundStation4)
	(calibration_target instrument3 GroundStation10)
	(supports instrument4 infrared0)
	(supports instrument4 spectrograph1)
	(supports instrument4 image5)
	(calibration_target instrument4 GroundStation3)
	(calibration_target instrument4 GroundStation10)
	(calibration_target instrument4 GroundStation11)
	(supports instrument5 image5)
	(supports instrument5 spectrograph1)
	(supports instrument5 thermograph4)
	(calibration_target instrument5 GroundStation6)
	(calibration_target instrument5 Star5)
	(supports instrument6 thermograph4)
	(supports instrument6 infrared2)
	(calibration_target instrument6 GroundStation6)
	(calibration_target instrument6 GroundStation4)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation1)
)
(:goal (and
	(have_image Star12 infrared0)
	(have_image Star13 infrared2)
	(have_image Star13 infrared0)
	(have_image Planet14 image3)
	(have_image Planet15 spectrograph1)
))

)
