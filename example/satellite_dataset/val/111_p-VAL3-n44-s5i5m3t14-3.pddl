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
	satellite3 - satellite
	instrument5 - instrument
	instrument6 - instrument
	instrument7 - instrument
	satellite4 - satellite
	instrument8 - instrument
	instrument9 - instrument
	image2 - mode
	spectrograph0 - mode
	infrared1 - mode
	Star0 - direction
	Star3 - direction
	GroundStation4 - direction
	Star10 - direction
	Star5 - direction
	Star11 - direction
	Star9 - direction
	Star6 - direction
	GroundStation7 - direction
	Star13 - direction
	GroundStation1 - direction
	Star12 - direction
	Star2 - direction
	GroundStation8 - direction
	Star14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 image2)
	(calibration_target instrument0 Star10)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
	(supports instrument1 infrared1)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 Star9)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation1)
	(supports instrument2 infrared1)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 Star9)
	(calibration_target instrument2 Star6)
	(calibration_target instrument2 GroundStation4)
	(calibration_target instrument2 Star3)
	(supports instrument3 infrared1)
	(supports instrument3 spectrograph0)
	(supports instrument3 image2)
	(calibration_target instrument3 Star10)
	(calibration_target instrument3 Star11)
	(calibration_target instrument3 Star9)
	(supports instrument4 spectrograph0)
	(supports instrument4 infrared1)
	(calibration_target instrument4 Star11)
	(calibration_target instrument4 Star2)
	(calibration_target instrument4 Star9)
	(calibration_target instrument4 Star5)
	(on_board instrument2 satellite2)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star13)
	(supports instrument5 spectrograph0)
	(supports instrument5 image2)
	(calibration_target instrument5 Star9)
	(calibration_target instrument5 GroundStation8)
	(supports instrument6 spectrograph0)
	(calibration_target instrument6 Star12)
	(supports instrument7 image2)
	(supports instrument7 infrared1)
	(supports instrument7 spectrograph0)
	(calibration_target instrument7 Star13)
	(calibration_target instrument7 GroundStation7)
	(calibration_target instrument7 Star6)
	(on_board instrument5 satellite3)
	(on_board instrument6 satellite3)
	(on_board instrument7 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation8)
	(supports instrument8 infrared1)
	(supports instrument8 image2)
	(supports instrument8 spectrograph0)
	(calibration_target instrument8 Star12)
	(calibration_target instrument8 GroundStation1)
	(supports instrument9 image2)
	(supports instrument9 infrared1)
	(supports instrument9 spectrograph0)
	(calibration_target instrument9 GroundStation8)
	(calibration_target instrument9 Star2)
	(on_board instrument8 satellite4)
	(on_board instrument9 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star0)
)
(:goal (and
	(pointing satellite3 Star10)
	(have_image Star14 infrared1)
	(have_image Phenomenon15 spectrograph0)
	(have_image Star16 spectrograph0)
	(have_image Phenomenon17 image2)
))

)
