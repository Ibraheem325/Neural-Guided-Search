(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	instrument5 - instrument
	instrument6 - instrument
	instrument7 - instrument
	infrared1 - mode
	infrared5 - mode
	spectrograph6 - mode
	image3 - mode
	spectrograph0 - mode
	image2 - mode
	image4 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation4 - direction
	GroundStation9 - direction
	GroundStation7 - direction
	GroundStation5 - direction
	GroundStation2 - direction
	GroundStation6 - direction
	Star3 - direction
	GroundStation8 - direction
	Phenomenon10 - direction
	Star11 - direction
	Planet12 - direction
	Phenomenon13 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 image4)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 GroundStation8)
	(supports instrument1 infrared1)
	(supports instrument1 spectrograph6)
	(calibration_target instrument1 GroundStation4)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 GroundStation5)
	(supports instrument2 image4)
	(calibration_target instrument2 GroundStation5)
	(calibration_target instrument2 GroundStation4)
	(calibration_target instrument2 GroundStation2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet12)
	(supports instrument3 infrared5)
	(supports instrument3 image4)
	(supports instrument3 image2)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 GroundStation9)
	(calibration_target instrument3 GroundStation2)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon13)
	(supports instrument4 spectrograph0)
	(calibration_target instrument4 GroundStation2)
	(calibration_target instrument4 GroundStation5)
	(calibration_target instrument4 GroundStation7)
	(supports instrument5 spectrograph0)
	(calibration_target instrument5 GroundStation6)
	(supports instrument6 image3)
	(supports instrument6 infrared1)
	(calibration_target instrument6 GroundStation8)
	(supports instrument7 infrared1)
	(supports instrument7 infrared5)
	(supports instrument7 spectrograph0)
	(calibration_target instrument7 GroundStation8)
	(calibration_target instrument7 Star3)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star11)
)
(:goal (and
	(pointing satellite0 GroundStation4)
	(pointing satellite1 GroundStation8)
	(have_image Phenomenon10 image4)
	(have_image Phenomenon10 image3)
	(have_image Star11 image2)
	(have_image Star11 infrared1)
	(have_image Planet12 spectrograph6)
	(have_image Phenomenon13 infrared1)
))

)
