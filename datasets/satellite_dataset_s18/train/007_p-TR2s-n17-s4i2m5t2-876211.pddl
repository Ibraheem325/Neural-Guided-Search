(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	satellite3 - satellite
	instrument4 - instrument
	thermograph2 - mode
	image4 - mode
	spectrograph3 - mode
	infrared0 - mode
	thermograph1 - mode
	Star0 - direction
	Star1 - direction
	Planet2 - direction
)
(:init
	(supports instrument0 image4)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
	(supports instrument1 thermograph2)
	(supports instrument1 image4)
	(supports instrument1 infrared0)
	(calibration_target instrument1 Star1)
	(supports instrument2 thermograph1)
	(supports instrument2 thermograph2)
	(supports instrument2 spectrograph3)
	(calibration_target instrument2 Star1)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star0)
	(supports instrument3 image4)
	(supports instrument3 thermograph1)
	(supports instrument3 thermograph2)
	(calibration_target instrument3 Star0)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star0)
	(supports instrument4 infrared0)
	(supports instrument4 spectrograph3)
	(supports instrument4 image4)
	(calibration_target instrument4 Star1)
	(on_board instrument4 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet2)
)
(:goal (and
	(pointing satellite0 Planet2)
	(pointing satellite1 Star1)
	(pointing satellite2 Star0)
	(have_image Planet2 spectrograph3)
))

)
