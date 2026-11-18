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
	image0 - mode
	thermograph2 - mode
	image3 - mode
	infrared4 - mode
	spectrograph1 - mode
	Star0 - direction
	Planet1 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 infrared4)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet1)
	(supports instrument1 thermograph2)
	(supports instrument1 image3)
	(supports instrument1 image0)
	(calibration_target instrument1 Star0)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star0)
	(supports instrument2 image0)
	(supports instrument2 image3)
	(calibration_target instrument2 Star0)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet1)
	(supports instrument3 thermograph2)
	(calibration_target instrument3 Star0)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet1)
)
(:goal (and
	(have_image Planet1 image3)
))

)
