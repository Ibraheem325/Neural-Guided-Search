(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	spectrograph4 - mode
	image0 - mode
	spectrograph3 - mode
	infrared1 - mode
	image2 - mode
	Star0 - direction
	Planet1 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 spectrograph4)
	(supports instrument0 infrared1)
	(supports instrument0 image0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet1)
	(supports instrument1 spectrograph3)
	(supports instrument1 spectrograph4)
	(calibration_target instrument1 Star0)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star0)
)
(:goal (and
	(pointing satellite0 Planet1)
	(have_image Planet1 image2)
))

)
