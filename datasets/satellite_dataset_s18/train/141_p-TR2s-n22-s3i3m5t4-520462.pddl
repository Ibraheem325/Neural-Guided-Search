(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	spectrograph1 - mode
	image4 - mode
	spectrograph3 - mode
	thermograph0 - mode
	infrared2 - mode
	GroundStation2 - direction
	Star0 - direction
	Star3 - direction
	Star1 - direction
	Star4 - direction
	Phenomenon5 - direction
	Star6 - direction
	Planet7 - direction
	Star8 - direction
)
(:init
	(supports instrument0 image4)
	(calibration_target instrument0 GroundStation2)
	(supports instrument1 infrared2)
	(supports instrument1 spectrograph1)
	(supports instrument1 spectrograph3)
	(calibration_target instrument1 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star6)
	(supports instrument2 thermograph0)
	(supports instrument2 spectrograph1)
	(supports instrument2 image4)
	(calibration_target instrument2 Star1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation2)
	(supports instrument3 spectrograph1)
	(calibration_target instrument3 Star3)
	(supports instrument4 infrared2)
	(supports instrument4 image4)
	(supports instrument4 spectrograph1)
	(calibration_target instrument4 Star1)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star0)
)
(:goal (and
	(pointing satellite0 GroundStation2)
	(pointing satellite2 Planet7)
	(have_image Star4 infrared2)
	(have_image Phenomenon5 thermograph0)
	(have_image Star6 spectrograph1)
	(have_image Planet7 image4)
	(have_image Star8 thermograph0)
))

)
