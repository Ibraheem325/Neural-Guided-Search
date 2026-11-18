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
	thermograph0 - mode
	thermograph1 - mode
	spectrograph2 - mode
	Star3 - direction
	Star1 - direction
	Star2 - direction
	Star0 - direction
	Star4 - direction
	Phenomenon5 - direction
	Star6 - direction
	Planet7 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 spectrograph2)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star2)
	(supports instrument1 spectrograph2)
	(supports instrument1 thermograph1)
	(calibration_target instrument1 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
	(supports instrument2 spectrograph2)
	(supports instrument2 thermograph0)
	(calibration_target instrument2 Star0)
	(supports instrument3 thermograph0)
	(supports instrument3 spectrograph2)
	(calibration_target instrument3 Star1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet7)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 Star2)
	(supports instrument5 thermograph1)
	(supports instrument5 spectrograph2)
	(calibration_target instrument5 Star0)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star1)
)
(:goal (and
	(pointing satellite1 Star4)
	(have_image Star4 thermograph1)
	(have_image Phenomenon5 thermograph1)
	(have_image Star6 spectrograph2)
	(have_image Planet7 thermograph1)
))

)
