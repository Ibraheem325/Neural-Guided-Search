(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	satellite1 - satellite
	instrument4 - instrument
	instrument5 - instrument
	instrument6 - instrument
	instrument7 - instrument
	instrument8 - instrument
	satellite2 - satellite
	instrument9 - instrument
	satellite3 - satellite
	instrument10 - instrument
	image3 - mode
	infrared1 - mode
	spectrograph0 - mode
	image2 - mode
	Star2 - direction
	Star7 - direction
	GroundStation9 - direction
	Star0 - direction
	Star6 - direction
	GroundStation11 - direction
	GroundStation1 - direction
	Star3 - direction
	Star4 - direction
	Star13 - direction
	Star5 - direction
	Star8 - direction
	GroundStation12 - direction
	GroundStation10 - direction
	Star14 - direction
	Star15 - direction
	Planet16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation11)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 image2)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 Star8)
	(calibration_target instrument1 Star6)
	(calibration_target instrument1 GroundStation9)
	(supports instrument2 infrared1)
	(supports instrument2 image3)
	(calibration_target instrument2 GroundStation10)
	(calibration_target instrument2 Star0)
	(calibration_target instrument2 Star5)
	(supports instrument3 spectrograph0)
	(supports instrument3 infrared1)
	(supports instrument3 image2)
	(calibration_target instrument3 Star5)
	(calibration_target instrument3 Star6)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
	(supports instrument4 image3)
	(supports instrument4 image2)
	(supports instrument4 infrared1)
	(calibration_target instrument4 GroundStation11)
	(calibration_target instrument4 Star6)
	(calibration_target instrument4 Star5)
	(supports instrument5 image2)
	(supports instrument5 image3)
	(supports instrument5 infrared1)
	(calibration_target instrument5 Star3)
	(calibration_target instrument5 Star13)
	(supports instrument6 infrared1)
	(calibration_target instrument6 Star3)
	(calibration_target instrument6 GroundStation1)
	(supports instrument7 infrared1)
	(calibration_target instrument7 Star4)
	(supports instrument8 spectrograph0)
	(calibration_target instrument8 Star13)
	(calibration_target instrument8 Star5)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(on_board instrument7 satellite1)
	(on_board instrument8 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet17)
	(supports instrument9 image3)
	(calibration_target instrument9 Star5)
	(calibration_target instrument9 GroundStation10)
	(on_board instrument9 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star7)
	(supports instrument10 image3)
	(supports instrument10 spectrograph0)
	(calibration_target instrument10 GroundStation10)
	(calibration_target instrument10 GroundStation12)
	(calibration_target instrument10 Star8)
	(on_board instrument10 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star15)
)
(:goal (and
	(pointing satellite3 GroundStation12)
	(have_image Star14 infrared1)
	(have_image Star15 image3)
	(have_image Planet16 infrared1)
	(have_image Planet17 infrared1)
))

)
