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
	spectrograph0 - mode
	image2 - mode
	image1 - mode
	Star1 - direction
	Star0 - direction
	Phenomenon2 - direction
	Star3 - direction
	Phenomenon4 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 image1)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star3)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 Star0)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star1)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 Star1)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star1)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 Star0)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star3)
	(supports instrument4 spectrograph0)
	(calibration_target instrument4 Star1)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star3)
	(supports instrument5 spectrograph0)
	(supports instrument5 image2)
	(supports instrument5 image1)
	(calibration_target instrument5 Star0)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Phenomenon2)
)
(:goal (and
	(pointing satellite0 Star1)
	(pointing satellite1 Star1)
	(have_image Phenomenon2 spectrograph0)
	(have_image Star3 spectrograph0)
	(have_image Phenomenon4 spectrograph0)
))

)
