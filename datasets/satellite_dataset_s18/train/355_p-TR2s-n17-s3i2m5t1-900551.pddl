(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	instrument5 - instrument
	spectrograph0 - mode
	spectrograph3 - mode
	spectrograph4 - mode
	image2 - mode
	spectrograph1 - mode
	Star0 - direction
	Star1 - direction
	Planet2 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 spectrograph4)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star0)
	(supports instrument1 image2)
	(calibration_target instrument1 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
	(supports instrument2 image2)
	(supports instrument2 spectrograph0)
	(supports instrument2 spectrograph4)
	(supports instrument2 spectrograph1)
	(calibration_target instrument2 Star0)
	(supports instrument3 spectrograph3)
	(supports instrument3 spectrograph0)
	(supports instrument3 image2)
	(calibration_target instrument3 Star0)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star1)
	(supports instrument4 spectrograph4)
	(supports instrument4 spectrograph3)
	(calibration_target instrument4 Star0)
	(supports instrument5 image2)
	(supports instrument5 spectrograph3)
	(supports instrument5 spectrograph4)
	(calibration_target instrument5 Star0)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star0)
)
(:goal (and
	(pointing satellite0 Star1)
	(have_image Star1 spectrograph3)
	(have_image Planet2 spectrograph1)
))

)
