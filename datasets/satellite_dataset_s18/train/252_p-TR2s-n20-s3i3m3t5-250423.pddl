(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	thermograph2 - mode
	infrared1 - mode
	spectrograph0 - mode
	GroundStation2 - direction
	GroundStation3 - direction
	Star1 - direction
	Star0 - direction
	Star4 - direction
	Planet5 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
)
(:init
	(supports instrument0 thermograph2)
	(calibration_target instrument0 Star0)
	(supports instrument1 thermograph2)
	(supports instrument1 infrared1)
	(calibration_target instrument1 Star1)
	(supports instrument2 spectrograph0)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
	(supports instrument3 thermograph2)
	(supports instrument3 infrared1)
	(calibration_target instrument3 Star4)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star8)
	(supports instrument4 infrared1)
	(supports instrument4 spectrograph0)
	(calibration_target instrument4 Star4)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star0)
)
(:goal (and
	(pointing satellite0 Star0)
	(pointing satellite1 Star1)
	(have_image Planet5 thermograph2)
	(have_image Star6 thermograph2)
	(have_image Star7 spectrograph0)
	(have_image Star8 spectrograph0)
))

)
