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
	satellite3 - satellite
	instrument9 - instrument
	instrument10 - instrument
	instrument11 - instrument
	satellite4 - satellite
	instrument12 - instrument
	instrument13 - instrument
	image2 - mode
	infrared1 - mode
	spectrograph0 - mode
	Star3 - direction
	Star0 - direction
	GroundStation1 - direction
	GroundStation8 - direction
	Star12 - direction
	Star11 - direction
	GroundStation7 - direction
	Star2 - direction
	Star6 - direction
	Star9 - direction
	Star10 - direction
	Star5 - direction
	GroundStation4 - direction
	Star13 - direction
	Star14 - direction
	Planet15 - direction
	Planet16 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 image2)
	(supports instrument0 infrared1)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 Star11)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 image2)
	(calibration_target instrument1 Star3)
	(calibration_target instrument1 GroundStation4)
	(supports instrument2 spectrograph0)
	(supports instrument2 infrared1)
	(supports instrument2 image2)
	(calibration_target instrument2 Star12)
	(calibration_target instrument2 Star6)
	(calibration_target instrument2 Star9)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star10)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 Star3)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 Star0)
	(supports instrument4 image2)
	(calibration_target instrument4 Star6)
	(calibration_target instrument4 Star3)
	(calibration_target instrument4 Star5)
	(supports instrument5 spectrograph0)
	(supports instrument5 infrared1)
	(calibration_target instrument5 GroundStation8)
	(calibration_target instrument5 Star2)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star6)
	(supports instrument6 image2)
	(supports instrument6 spectrograph0)
	(supports instrument6 infrared1)
	(calibration_target instrument6 Star3)
	(supports instrument7 image2)
	(calibration_target instrument7 Star3)
	(calibration_target instrument7 Star6)
	(calibration_target instrument7 GroundStation8)
	(supports instrument8 infrared1)
	(supports instrument8 image2)
	(calibration_target instrument8 Star10)
	(calibration_target instrument8 GroundStation1)
	(calibration_target instrument8 Star0)
	(calibration_target instrument8 Star2)
	(on_board instrument6 satellite2)
	(on_board instrument7 satellite2)
	(on_board instrument8 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star9)
	(supports instrument9 image2)
	(calibration_target instrument9 Star5)
	(calibration_target instrument9 GroundStation4)
	(calibration_target instrument9 GroundStation8)
	(supports instrument10 image2)
	(supports instrument10 spectrograph0)
	(calibration_target instrument10 GroundStation7)
	(calibration_target instrument10 Star11)
	(calibration_target instrument10 GroundStation4)
	(calibration_target instrument10 Star12)
	(supports instrument11 image2)
	(calibration_target instrument11 Star6)
	(calibration_target instrument11 Star2)
	(calibration_target instrument11 Star10)
	(on_board instrument9 satellite3)
	(on_board instrument10 satellite3)
	(on_board instrument11 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet15)
	(supports instrument12 spectrograph0)
	(supports instrument12 image2)
	(supports instrument12 infrared1)
	(calibration_target instrument12 Star10)
	(calibration_target instrument12 Star9)
	(supports instrument13 image2)
	(supports instrument13 spectrograph0)
	(supports instrument13 infrared1)
	(calibration_target instrument13 GroundStation4)
	(calibration_target instrument13 Star5)
	(on_board instrument12 satellite4)
	(on_board instrument13 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star3)
)
(:goal (and
	(pointing satellite0 Star0)
	(have_image Star13 spectrograph0)
	(have_image Star14 spectrograph0)
	(have_image Planet15 spectrograph0)
	(have_image Planet16 spectrograph0)
))

)
