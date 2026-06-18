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
	satellite2 - satellite
	instrument8 - instrument
	satellite3 - satellite
	instrument9 - instrument
	instrument10 - instrument
	instrument11 - instrument
	spectrograph0 - mode
	infrared1 - mode
	image2 - mode
	Star10 - direction
	GroundStation1 - direction
	Star5 - direction
	Star3 - direction
	Star2 - direction
	GroundStation8 - direction
	GroundStation4 - direction
	Star9 - direction
	Star0 - direction
	Star6 - direction
	GroundStation7 - direction
	Star11 - direction
	Phenomenon12 - direction
	Phenomenon13 - direction
	Planet14 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 image2)
	(calibration_target instrument1 GroundStation4)
	(calibration_target instrument1 Star10)
	(supports instrument2 spectrograph0)
	(supports instrument2 infrared1)
	(calibration_target instrument2 GroundStation4)
	(calibration_target instrument2 Star5)
	(calibration_target instrument2 GroundStation7)
	(supports instrument3 image2)
	(supports instrument3 spectrograph0)
	(supports instrument3 infrared1)
	(calibration_target instrument3 GroundStation1)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 Star10)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star10)
	(supports instrument4 infrared1)
	(calibration_target instrument4 GroundStation4)
	(calibration_target instrument4 Star5)
	(calibration_target instrument4 Star6)
	(supports instrument5 infrared1)
	(calibration_target instrument5 Star3)
	(supports instrument6 spectrograph0)
	(supports instrument6 image2)
	(calibration_target instrument6 GroundStation8)
	(supports instrument7 spectrograph0)
	(supports instrument7 image2)
	(supports instrument7 infrared1)
	(calibration_target instrument7 GroundStation8)
	(calibration_target instrument7 Star2)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(on_board instrument6 satellite1)
	(on_board instrument7 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star6)
	(supports instrument8 spectrograph0)
	(supports instrument8 image2)
	(calibration_target instrument8 Star9)
	(calibration_target instrument8 GroundStation4)
	(on_board instrument8 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation7)
	(supports instrument9 spectrograph0)
	(supports instrument9 infrared1)
	(supports instrument9 image2)
	(calibration_target instrument9 Star9)
	(supports instrument10 image2)
	(supports instrument10 infrared1)
	(supports instrument10 spectrograph0)
	(calibration_target instrument10 Star6)
	(calibration_target instrument10 Star0)
	(calibration_target instrument10 GroundStation7)
	(supports instrument11 spectrograph0)
	(calibration_target instrument11 GroundStation7)
	(on_board instrument9 satellite3)
	(on_board instrument10 satellite3)
	(on_board instrument11 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation4)
)
(:goal (and
	(pointing satellite2 GroundStation1)
	(pointing satellite3 GroundStation8)
	(have_image Star11 infrared1)
	(have_image Phenomenon12 infrared1)
	(have_image Phenomenon13 spectrograph0)
	(have_image Planet14 infrared1)
))

)
