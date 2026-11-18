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
	image0 - mode
	spectrograph1 - mode
	GroundStation0 - direction
	Star4 - direction
	GroundStation5 - direction
	GroundStation7 - direction
	Star6 - direction
	Star1 - direction
	Star3 - direction
	GroundStation2 - direction
	Star8 - direction
	Star9 - direction
	Planet10 - direction
	Planet11 - direction
	Planet12 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
	(supports instrument1 image0)
	(calibration_target instrument1 Star1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star6)
	(supports instrument2 image0)
	(supports instrument2 spectrograph2)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 Star3)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation0)
)
(:goal (and
	(have_image Star8 image0)
	(have_image Star9 image0)
	(have_image Planet10 image0)
	(have_image Planet11 spectrograph2)
	(have_image Planet12 image0)
))

)
