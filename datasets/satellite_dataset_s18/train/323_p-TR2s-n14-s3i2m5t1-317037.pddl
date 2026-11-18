(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	spectrograph2 - mode
	infrared3 - mode
	spectrograph0 - mode
	image1 - mode
	spectrograph4 - mode
	Star0 - direction
	Star1 - direction
	Phenomenon2 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon2)
	(supports instrument1 image1)
	(supports instrument1 spectrograph4)
	(calibration_target instrument1 Star0)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star1)
	(supports instrument2 spectrograph2)
	(supports instrument2 infrared3)
	(calibration_target instrument2 Star0)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star0)
)
(:goal (and
	(pointing satellite1 Star1)
	(have_image Star1 spectrograph0)
	(have_image Phenomenon2 spectrograph0)
))

)
