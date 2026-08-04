(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	satellite5 - satellite
	instrument5 - instrument
	satellite6 - satellite
	instrument6 - instrument
	satellite7 - satellite
	instrument7 - instrument
	image2 - mode
	infrared1 - mode
	spectrograph0 - mode
	image3 - mode
	Star0 - direction
	Star3 - direction
	Star2 - direction
	Star1 - direction
	Star4 - direction
	Star5 - direction
	Star6 - direction
	Planet7 - direction
	Phenomenon8 - direction
	Planet9 - direction
	Planet10 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet7)
	(supports instrument1 infrared1)
	(calibration_target instrument1 Star4)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet10)
	(supports instrument2 image2)
	(supports instrument2 infrared1)
	(supports instrument2 image3)
	(calibration_target instrument2 Star4)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star4)
	(supports instrument3 image2)
	(supports instrument3 image3)
	(supports instrument3 infrared1)
	(calibration_target instrument3 Star3)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star5)
	(supports instrument4 image2)
	(supports instrument4 spectrograph0)
	(supports instrument4 image3)
	(calibration_target instrument4 Star1)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star2)
	(supports instrument5 spectrograph0)
	(supports instrument5 image2)
	(supports instrument5 image3)
	(calibration_target instrument5 Star2)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Star2)
	(supports instrument6 spectrograph0)
	(calibration_target instrument6 Star1)
	(on_board instrument6 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Planet9)
	(supports instrument7 infrared1)
	(supports instrument7 image2)
	(calibration_target instrument7 Star4)
	(on_board instrument7 satellite7)
	(power_avail satellite7)
	(pointing satellite7 Star3)
)
(:goal (and
	(pointing satellite0 Planet9)
	(pointing satellite1 Planet9)
	(pointing satellite4 Planet9)
	(pointing satellite5 Star3)
	(pointing satellite6 Star6)
	(pointing satellite7 Star6)
	(have_image Star5 image3)
	(have_image Star6 image3)
	(have_image Planet7 image2)
	(have_image Phenomenon8 spectrograph0)
	(have_image Planet9 image2)
	(have_image Planet10 image3)
))

)
