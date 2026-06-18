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
	satellite3 - satellite
	instrument6 - instrument
	instrument7 - instrument
	instrument8 - instrument
	instrument9 - instrument
	satellite4 - satellite
	instrument10 - instrument
	instrument11 - instrument
	instrument12 - instrument
	instrument13 - instrument
	spectrograph0 - mode
	image3 - mode
	image2 - mode
	image4 - mode
	infrared1 - mode
	GroundStation11 - direction
	Star0 - direction
	GroundStation9 - direction
	Star7 - direction
	Star5 - direction
	GroundStation1 - direction
	Star8 - direction
	Star3 - direction
	GroundStation10 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	Star6 - direction
	Star12 - direction
	Star13 - direction
	Star14 - direction
	Star15 - direction
)
(:init
	(supports instrument0 image4)
	(supports instrument0 image2)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star0)
	(supports instrument1 image2)
	(supports instrument1 infrared1)
	(supports instrument1 image4)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 Star3)
	(calibration_target instrument1 Star0)
	(supports instrument2 image3)
	(supports instrument2 image4)
	(calibration_target instrument2 Star8)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
	(supports instrument3 infrared1)
	(supports instrument3 image2)
	(calibration_target instrument3 GroundStation9)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star15)
	(supports instrument4 image2)
	(calibration_target instrument4 Star5)
	(calibration_target instrument4 Star7)
	(calibration_target instrument4 Star8)
	(supports instrument5 image3)
	(supports instrument5 image2)
	(supports instrument5 infrared1)
	(calibration_target instrument5 Star3)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation4)
	(supports instrument6 spectrograph0)
	(supports instrument6 image4)
	(calibration_target instrument6 GroundStation9)
	(calibration_target instrument6 Star3)
	(calibration_target instrument6 GroundStation2)
	(supports instrument7 image2)
	(supports instrument7 image3)
	(calibration_target instrument7 Star5)
	(calibration_target instrument7 GroundStation1)
	(supports instrument8 spectrograph0)
	(supports instrument8 image4)
	(calibration_target instrument8 Star5)
	(calibration_target instrument8 Star7)
	(calibration_target instrument8 Star8)
	(supports instrument9 image3)
	(supports instrument9 image4)
	(supports instrument9 infrared1)
	(calibration_target instrument9 Star8)
	(calibration_target instrument9 GroundStation1)
	(on_board instrument6 satellite3)
	(on_board instrument7 satellite3)
	(on_board instrument8 satellite3)
	(on_board instrument9 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star14)
	(supports instrument10 image2)
	(supports instrument10 spectrograph0)
	(supports instrument10 image4)
	(calibration_target instrument10 Star3)
	(calibration_target instrument10 Star8)
	(calibration_target instrument10 GroundStation1)
	(supports instrument11 spectrograph0)
	(supports instrument11 image2)
	(supports instrument11 image3)
	(calibration_target instrument11 GroundStation4)
	(calibration_target instrument11 GroundStation10)
	(supports instrument12 image3)
	(calibration_target instrument12 GroundStation4)
	(calibration_target instrument12 GroundStation2)
	(supports instrument13 image3)
	(calibration_target instrument13 Star6)
	(on_board instrument10 satellite4)
	(on_board instrument11 satellite4)
	(on_board instrument12 satellite4)
	(on_board instrument13 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star15)
)
(:goal (and
	(pointing satellite3 Star6)
	(have_image Star12 image3)
	(have_image Star13 image4)
	(have_image Star14 infrared1)
	(have_image Star15 spectrograph0)
))

)
