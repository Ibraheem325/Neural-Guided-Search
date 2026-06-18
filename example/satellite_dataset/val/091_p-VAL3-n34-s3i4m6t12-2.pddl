(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	instrument4 - instrument
	satellite2 - satellite
	instrument5 - instrument
	instrument6 - instrument
	instrument7 - instrument
	infrared3 - mode
	image5 - mode
	infrared2 - mode
	thermograph1 - mode
	image4 - mode
	spectrograph0 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	GroundStation10 - direction
	GroundStation3 - direction
	GroundStation8 - direction
	GroundStation7 - direction
	GroundStation11 - direction
	GroundStation9 - direction
	GroundStation6 - direction
	Star5 - direction
	Phenomenon12 - direction
	Planet13 - direction
	Planet14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 GroundStation7)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet13)
	(supports instrument1 image4)
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 GroundStation11)
	(supports instrument2 infrared2)
	(supports instrument2 image5)
	(supports instrument2 infrared3)
	(calibration_target instrument2 GroundStation6)
	(calibration_target instrument2 GroundStation10)
	(supports instrument3 image5)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 GroundStation3)
	(calibration_target instrument3 Star5)
	(calibration_target instrument3 GroundStation9)
	(supports instrument4 thermograph1)
	(supports instrument4 image5)
	(calibration_target instrument4 GroundStation9)
	(calibration_target instrument4 GroundStation6)
	(calibration_target instrument4 Star5)
	(calibration_target instrument4 GroundStation7)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation8)
	(supports instrument5 thermograph1)
	(calibration_target instrument5 GroundStation9)
	(calibration_target instrument5 GroundStation11)
	(supports instrument6 infrared2)
	(calibration_target instrument6 GroundStation6)
	(supports instrument7 infrared2)
	(supports instrument7 image4)
	(calibration_target instrument7 Star5)
	(calibration_target instrument7 GroundStation6)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation6)
)
(:goal (and
	(pointing satellite2 GroundStation11)
	(have_image Phenomenon12 infrared2)
	(have_image Phenomenon12 thermograph1)
	(have_image Planet13 image4)
	(have_image Planet13 infrared3)
	(have_image Planet14 image5)
	(have_image Phenomenon15 spectrograph0)
	(have_image Phenomenon15 infrared2)
))

)
