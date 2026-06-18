(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	instrument6 - instrument
	image3 - mode
	infrared1 - mode
	infrared5 - mode
	spectrograph0 - mode
	image2 - mode
	image4 - mode
	Star5 - direction
	GroundStation7 - direction
	GroundStation9 - direction
	Star1 - direction
	Star12 - direction
	Star3 - direction
	GroundStation10 - direction
	GroundStation2 - direction
	GroundStation11 - direction
	GroundStation0 - direction
	GroundStation4 - direction
	GroundStation8 - direction
	GroundStation6 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 GroundStation9)
	(supports instrument1 image4)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 GroundStation4)
	(calibration_target instrument1 Star12)
	(calibration_target instrument1 GroundStation0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
	(supports instrument2 infrared1)
	(calibration_target instrument2 GroundStation10)
	(calibration_target instrument2 Star3)
	(calibration_target instrument2 GroundStation2)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation7)
	(supports instrument3 image3)
	(supports instrument3 infrared5)
	(calibration_target instrument3 GroundStation10)
	(calibration_target instrument3 GroundStation0)
	(calibration_target instrument3 GroundStation8)
	(supports instrument4 spectrograph0)
	(supports instrument4 infrared5)
	(supports instrument4 image2)
	(calibration_target instrument4 GroundStation8)
	(calibration_target instrument4 GroundStation2)
	(supports instrument5 spectrograph0)
	(supports instrument5 infrared5)
	(supports instrument5 image3)
	(calibration_target instrument5 GroundStation11)
	(calibration_target instrument5 GroundStation8)
	(calibration_target instrument5 GroundStation2)
	(supports instrument6 image3)
	(supports instrument6 spectrograph0)
	(calibration_target instrument6 GroundStation6)
	(calibration_target instrument6 GroundStation8)
	(calibration_target instrument6 GroundStation4)
	(calibration_target instrument6 GroundStation0)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(on_board instrument6 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation11)
)
(:goal (and
	(pointing satellite0 GroundStation6)
	(pointing satellite2 GroundStation4)
	(have_image Phenomenon13 infrared1)
	(have_image Phenomenon14 image3)
	(have_image Phenomenon15 image4)
	(have_image Phenomenon16 image4)
	(have_image Phenomenon16 image3)
))

)
